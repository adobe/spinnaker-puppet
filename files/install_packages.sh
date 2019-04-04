#!/usr/bin/env bash
#Copyright 2019 Adobe. All rights reserved.
#This file is licensed to you under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License. You may obtain a copy
#of the License at http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software distributed under
#the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
#OF ANY KIND, either express or implied. See the License for the specific language
#governing permissions and limitations under the License.

################################################################################################################################################################
# The script will be used when Baking AMIs with Spinnaker. It does several things:
# The script assumes that all yum repos are configured when the instance is bootstrapped.
# 1. It will first install all dependencies that we need before installing actual RPM packages. This step includes installing
#    the aws cli, python and jq.
# 2. Several standardized directories will be created as seen in the create_dirs function. These directories will have a specific role in the
#    Spinnaker echosystem.
# 3. All environment variables provided in the Spinnaker UI will then be exported and added to the "environment_variables" variable.
#    For secrets, the script will look for the indicated secrets provider such as ssm, vault and will query it to get the value for the submitted entity.
# 4. All packages added from the Spinnaker interface and will be installed in the exact order as seen in the UI.
# 5. For each packet, the script will first check if there are any files located in the "/opt/bake-scripts" directory. These scripts are included and copied
#    in this path when the packet is installed. If files are found, it will create a new directory named after the packet
#    in /opt/bake-scripts-finished/${package_name}.
# 6. All scripts from /opt/bake-scripts (if any) will be executed with all environment variables.
#
# - by default, environment variables configured using the Spinnaker UI will be persisted to disk; use the persist_variables trigger to disable this feature
# - all AMIs will have their initramfs rebuilt automatically so that root volumes are extended one the instance is bootstrapped
################################################################################################################################################################
set -e

function log() {
    date=`date '+%Y-%m-%d %H:%M:%S'`
    echo "[$date] - $1" >&2
}

log "packages=$packages"
log "upgrade=$upgrade"

upgrade=`echo $upgrade | sed 's/^"\(.*\)"$/\1/'`
packages=`echo $packages | sed 's/^"\(.*\)"$/\1/' | sed 's/,/ /g'`
availability_zone=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
region="`echo $availability_zone | sed 's/[a-z]$//'`"
persist_variables=${persist_variables:-true}
bake_dir="/opt/bake-scripts"
bake_dir_finished="/opt/bake-scripts-finished"
bake_start_time_seconds=`date +%s`
timer_start_seconds=

function install_dependencies() {

    if [[ ! $ami_name == *Base ]]; then
        log "Not baking base image. Assuming dependencies already installed."
        return
    fi

    start_timer
    sudo yum install epel-release -y || sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo yum install redhat-lsb -y || sudo yum install redhat-lsb-core -y
    lsb_distid=$(lsb_release  -i | tr -d "\t "| cut -f 2 -d ":")
    major_release=$(lsb_release -r | tr -d "\t" | cut -f 2 -d ":" | cut -f 1 -d ".")
    log "lsb_distid=${lsb_distid}"
    log "major_release=${major_release}"

    sudo yum install gcc gcc-c++ jq -y
    case $lsb_distid in
        CentOS)
            sudo yum install python python-pip python-devel python-setuptools -y
            sudo yum install sssd-common -y
        ;;
        Amazon)
           case $major_release in
                2)
                   sudo yum install python python-pip python-devel python-setuptools -y
                   sudo yum install sssd-common -y
           esac
        ;;
        AmazonAMI)
            case $major_release in
                2014)
                    sudo sudo yum install python27 python27-pip python27-devel python27-setuptools -y
                    sudo ln -s /usr/bin/pip-2.7 /usr/bin/pip
                    sudo pip install setuptools --upgrade --ignore-installed
                ;;
                2017)
                    sudo yum install python27 python27-pip python27-devel python27-setuptools -y
                    sudo yum install sssd-common -y
            esac
    esac
    sudo pip install -U awscli boto boto3
    log "[TIMER] Installed dependencies in $(get_elapsed_time_in_seconds) seconds"
}


function get_env_vars() {

    environment_variables=
    for idx in {1..10}; do
        var=${1}_${idx}
        environment_variables="${environment_variables} $(echo $(eval echo "\$$var") | sed -e 's/,/\n/g')"
    done
    echo $environment_variables
}


function get_secrets() {

    log "Retrieving secret vars"
    environment_variables=
    for idx in {1..10}; do
        secret_list=
        var=bootstrap_secrets_${idx}
        vars=$(eval echo "\$$var")
        set -f
        array=(${vars//,/ })
        for i in "${!array[@]}"
        do
            key=$(echo ${array[i]} | cut -d "=" -f 1)
            value=$(echo ${array[i]} | cut -d "=" -f 2)

            secret_provider=$(echo $value | cut -d ":" -f 1)
            secret_provider_key=$(echo $(echo $value | cut -d ":" -f 2) | sed 's/\/\///')
            case $secret_provider in
                ssm)
                    secret_value=$(retrieve_ssm_secret_value $secret_provider_key)
                    secret_list="${secret_list} ${key}=${secret_value}"
                ;;
                vault)
                    :
                ;;
                *)
                    :
            esac
        done
        environment_variables="${environment_variables} ${secret_list}"
    done
    echo $environment_variables
}

function retrieve_ssm_secret_value() {
    ssm_key=$1
    log "Retrieving SSM secret for key: ${ssm_key}"
    awscli=$(aws ssm get-parameters --name ${ssm_key} --with-decryption --region ${region})
    secret=$(echo $awscli | jq -r ".Parameters[0].Value")
    echo $secret
}

# NOT used but can be used in the future to install repositories
function create_repo() {

    repository_name=$1
    repository_url=$2
    repository_user=$3
    repository_password=$4
    metadata_expire_seconds=$5

    if [[ -z $repository_user || -z $repository_password ]]
    then
        log "No yum credentials found in the environment variables. Error creating $repository_name."
        log "Are repository_user/repository_password defined?"
        log "########################################################################"
        exit 1
    fi

    if [[ -f /etc/yum.repos.d/${repository_name}.repo ]]
    then
        log "Repository ${repository_name} already exists. Enabling it just to make sure."
        log "########################################################################"
        sudo sed -i 's/enabled.*/enabled=1/' /etc/yum.repos.d/${repository_name}.repo
        return 0
    fi

cat > /tmp/${repository_name}.repo <<EOF
[${repository_name}]
name=${repository_name}
baseurl=https://${repository_user}:${repository_password}@${repository_url}
enabled=1
gpgcheck=0
metadata_expire=${metadata_expire_seconds}
EOF
    sudo mv /tmp/${repository_name}.repo /etc/yum.repos.d/${repository_name}.repo
    exit_code=$?
    if [[ exit_code -eq 0 ]]
    then
        log "Added repository: ${repository_name}.repo pointing to ${repository_url}"
        log "########################################################################"
        yum clean all
    else
        log "Failed to add repository: ${repository_name}.repo"
        log "########################################################################"
    fi
}


function create_dirs() {

    sudo mkdir -p /opt/bake-scripts/
    sudo mkdir -p /opt/bake-scripts-finished/
    sudo mkdir -p /opt/shutdown-scripts/
    sudo mkdir -p /opt/startup-scripts/
    sudo chmod 744 -R /opt/bake-scripts/
    sudo chmod 744 -R /opt/shutdown-scripts/
    sudo chmod 744 -R /opt/startup-scripts/
}

# Executes all scripts from $bake_dir
# Then moves them to $bake_dir_finished/$package_name
function run_all_bake_scripts() {

    package_name=$1
    log "Looking up bake scripts in ${bake_dir} for ${package_name}"
    if [ "$(sudo ls -A $bake_dir)" ]; then
        log "Found bake files in ${bake_dir}"
        executed_count=0
        bake_files="$(sudo find $bake_dir -type f)"
        for script in $bake_files; do
            execute_script $script
        done
        log "Executed ${executed_count} scripts from ${bake_dir}"
    else
        log "No bake files found in ${bake_dir}, skipping..."
    fi
}

function execute_script() {

    script=$1
    log "Executing bake script ${script}"
    start_timer
    sudo ${all_environment_variables} -E -S /bin/bash $script
    exit_code=$?
    execution_time_seconds=$(get_elapsed_time_in_seconds)
    if [[ exit_code -eq 0 ]]
    then
        log "[TIMER] Script ${script} executed successfully in ${execution_time_seconds} seconds"
        log "########################################################################"
        executed_count=$(expr $executed_count + 1)
    else
        log "[TIMER] Failed to execute script: ${script}. Failed after ${execution_time_seconds} seconds"
        log "########################################################################"
        exit 1
    fi
}


function start_timer() {
    timer_start_seconds=`date +%s`
}

function get_elapsed_time_in_seconds() {
    timer_end_seconds=`date +%s`
    execution_time_seconds=$((timer_end_seconds-timer_start_seconds))
    echo $execution_time_seconds
}


function move_bake_scripts_to_finished() {

    package_name=$1
    if [ "$(sudo ls -A $bake_dir)" ]; then
        finished_folder="${bake_dir_finished}/${package_name}"
        log "Moving bake scripts to the finished folder: ${bake_dir}/* -> ${finished_folder}"
        sudo rm -rf $finished_folder
        sudo mkdir -p $finished_folder
        sudo mv $bake_dir/* $finished_folder
        log "Finished"
    fi
}

function install_rpms() {

    packages=$1
    if [[ "$upgrade" == "true" ]]; then
        sudo yum -y update
    fi

    log "Installing: ${packages}"
    for package_name in $packages; do
        log "Removing ${package_name} (in case it exists), to (re)apply bake scripts and ensure latest version"
        sudo rpm -e --nodeps $package_name || true
        log "Installing ${package_name}"
        sudo yum -y install $package_name
        run_all_bake_scripts $package_name
        move_bake_scripts_to_finished $package_name
    done
}

function persist_variables() {

    environment_variables=$1
    sudo rm -rf /etc/profile.d/spinnaker_bake.sh
    if [ -z "$environment_variables" ]
    then
        log "No environment variables defined bootstrap_env_* or bootstrap_secrets_*. Will not persist any env vars."
        log "########################################################################"
        return
    fi

    for variable in $environment_variables; do
        echo export \'$variable\'  | sudo tee -a /etc/profile.d/spinnaker_bake.sh  > /dev/null
    done
    exit_code=$?
    if [[ exit_code -eq 0 ]]
    then
        sudo chmod 600 /etc/profile.d/spinnaker_bake.sh
        log "Added environment variables to /etc/profile.d/spinnaker_bake.sh"
        log "########################################################################"
    else
        log "Failed to add environment variables to /etc/profile.d/spinnaker_bake.sh"
        log "########################################################################"
        exit 1
    fi
}

function log_disk_space() {
    echo "$(df -h)"
}

function main() {

    log_disk_space
    install_dependencies

    bootstrap_env=$(get_env_vars bootstrap_env)
    bootstrap_env="${bootstrap_env} OS_VERSION=${ami_os}"
    export $bootstrap_env
    bake_env=$(get_env_vars bake_env)
    export $bake_env
    secrets=$(get_secrets)
    export $secrets
    log "########################################################################"
    log "Running with bootstrap vars: ${bootstrap_env}"
    log "Running with bake vars: ${bake_env}"
    log "########################################################################"

    if [[ -z $persist_variables || $persist_variables == true  ]]
    then
        persistent_env="${bootstrap_env} ${secrets}"
        persist_variables "${persistent_env}"
    else
        log "Environment variables will not be persisted on disk"
        log "########################################################################"
    fi

    create_dirs

    export all_environment_variables="${bootstrap_env} ${secrets} ${bake_env}"
    install_rpms "$packages"
    log_disk_space

    bake_end_time_seconds=`date +%s`
    bake_execution_time_seconds=$((bake_end_time_seconds-bake_start_time_seconds))
    log "[TIMER] Finished bake in a total of ${bake_execution_time_seconds} seconds"
}

main
