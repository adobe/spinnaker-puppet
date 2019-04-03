#Copyright 2019 Adobe. All rights reserved.
#This file is licensed to you under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License. You may obtain a copy
#of the License at http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software distributed under
#the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
#OF ANY KIND, either express or implied. See the License for the specific language
#governing permissions and limitations under the License.

class spinnaker::params {

  $spinnaker_timezone = $::spinnaker_timezone ? {
    undef   => 'UTC',
    default => $::spinnaker_timezone,
  }

  $spinnaker_version = $::spinnaker_version ? {
    undef   => installed,
    default => $::spinnaker_version,
  }

  $clouddriver_version = $::clouddriver_version ? {
    undef   => installed,
    default => $::clouddriver_version,
  }

  $deck_version = $::deck_version ? {
    undef   => installed,
    default => $::deck_version,
  }

  $echo_version = $::echo_version ? {
    undef   => installed,
    default => $::echo_version,
  }

  $fiat_version = $::fiat_version ? {
    undef   => installed,
    default => $::fiat_version,
  }

  $front50_version = $::front50_version ? {
    undef   => installed,
    default => $::front50_version,
  }

  $igor_version = $::igor_version ? {
    undef   => installed,
    default => $::igor_version,
  }

  $orca_version = $::orca_version ? {
    undef   => installed,
    default => $::orca_version,
  }

  $rosco_version = $::rosco_version ? {
    undef   => installed,
    default => $::rosco_version,
  }

  $monitoring_daemon_version = $::monitoring_daemon_version ? {
    undef   => installed,
    default => $::monitoring_daemon_version,
  }

  $kubectl_version = $::kubectl_version ? {
    undef   =>  $::kubernetes_enabled ? {
                  undef   => undef,
                  default => installed,
                },
    default => $::kubectl_version,
  }

  $clouddriver_assumerole = $::clouddriver_assumerole ? {
    undef   => undef,
    default => $::clouddriver_assumerole,
  }

  $runas_user = $::runas_user ? {
    undef   => 'root',
    default => $::runas_user,
  }

  $runas_group = $::runas_group ? {
    undef   => 'root',
    default => $::runas_group,
  }

  $aws_enabled = $::aws_enabled ? {
    undef   => false,
    default => $::aws_enabled,
  }

  $aws_default_region = $::aws_default_region ? {
    undef   => 'us-east-1',
    default => $::aws_default_region,
  }

  $aws_primary_credentials = $::aws_primary_credentials ? {
    undef   => 'default',
    default => $::aws_primary_credentials,
  }

  $aws_default_iam_role = $::aws_default_iam_role ? {
    undef   => undef,
    default => $::aws_default_iam_role,
  }

  $aws_default_storage_bucket = $::aws_default_storage_bucket ? {
    undef   => undef,
    default => $::aws_default_storage_bucket,
  }

  $front50_cassandra_enabled = $::front50_cassandra_enabled ? {
    undef   => false,
    default => $::front50_cassandra_enabled,
  }

  $front50_redis_enabled = $::front50_redis_enabled ? {
    undef   => true,
    default => $::front50_redis_enabled,
  }

  $front50_s3_enabled = $::front50_s3_enabled ? {
    undef   => false,
    default => $::front50_s3_enabled,
  }

  $front50_gcs_enabled = $::front50_gcs_enabled ? {
    undef   => false,
    default => $::front50_gcs_enabled,
  }

  $front50_azs_enabled = $::front50_azs_enabled ? {
    undef   => false,
    default => $::front50_azs_enabled,
  }

  $front50_azs_storageAccountName = $::front50_azs_storageAccountName ? {
    undef   => undef,
    default => $::front50_azs_storageAccountName,
  }

  $front50_azs_storageAccountKey = $::front50_azs_storageAccountKey ? {
    undef   => undef,
    default => $::front50_azs_storageAccountKey,
  }

  $front50_azs_storageContainerName = $::front50_azs_storageContainerName ? {
    undef   => 'front50',
    default => $::front50_azs_storageContainerName,
  }

  $igor_enabled = $::igor_enabled ? {
    undef   => false,
    default => $::igor_enabled,
  }

  $jenkins_enabled = $::jenkins_enabled ? {
    undef   => false,
    default => $::jenkins_enabled,
  }

  $deck_baseurl = $::deck_baseurl ? {
    undef   => undef,
    default => $::deck_baseurl,
  }

  $deck_gateurl = $::deck_gateurl ? {
    undef   => undef,
    default => $::deck_gateurl,
  }

  $deck_domain = $::deck_domain ? {
    undef   => undef,
    default => $::deck_domain,
  }

  $deck_auth_enabled = $::deck_auth_enabled ? {
    undef   => true,
    default => $::deck_auth_enabled,
  }

  $echo_port = $::echo_port ? {
    undef   => '8009',
    default => $::echo_port,
  }

  $echo_cassandra_enabled = $::echo_cassandra_enabled ? {
    undef   => false,
    default => $::echo_cassandra_enabled,
  }

  $echo_inMemory_enabled = $::echo_inMemory_enabled ? {
    undef   => true,
    default => $::echo_inMemory_enabled,
  }

  $echo_cron_enabled = $::echo_cron_enabled ? {
    undef   => true,
    default => $::echo_cron_enabled,
  }

  $echo_mail_enabled = $::echo_mail_enabled ? {
    undef   => false,
    default => $::echo_mail_enabled,
  }

  $echo_mail_host = $::echo_mail_host ? {
    undef   => undef,
    default => $::echo_mail_host,
  }

  $echo_mail_fromAddress = $::echo_mail_fromAddress ? {
    undef   => undef,
    default => $::echo_mail_fromAddress,
  }

  $echo_hipchat_enabled = $::echo_hipchat_enabled ? {
    undef   => false,
    default => $::echo_hipchat_enabled,
  }

  $echo_hipchat_url = $::echo_hipchat_url ? {
    undef   => undef,
    default => $::echo_hipchat_url,
  }

  $echo_hipchat_token = $::echo_hipchat_token ? {
    undef   => undef,
    default => $::echo_hipchat_token,
  }

  $echo_hipchat_botName = $::echo_hipchat_botName ? {
    undef   => undef,
    default => $::echo_hipchat_botName,
  }

  $echo_sms_enabled = $::echo_sms_enabled ? {
    undef   => false,
    default => $::echo_sms_enabled,
  }

  $echo_sms_account = $::echo_sms_account ? {
    undef   => undef,
    default => $::echo_sms_account,
  }

  $echo_sms_token = $::echo_sms_token ? {
    undef   => undef,
    default => $::echo_sms_token,
  }

  $echo_sms_from = $::echo_sms_from ? {
    undef   => undef,
    default => $::echo_sms_from,
  }

  $echo_slack_enabled = $::echo_slack_enabled ? {
    undef   => true,
    default => $::echo_slack_enabled,
  }

  $echo_slack_token = $::echo_slack_token ? {
    undef   => undef,
    default => $::echo_slack_token,
  }

  $echo_slack_botname = $::echo_slack_botname ? {
    undef   => 'spinnaker',
    default => $::echo_slack_botname,
  }

  $default_protocol = $::default_protocol ? {
    undef   => 'http',
    default => $::default_protocol,
  }

  $default_host = $::default_host ? {
    undef   => 'localhost',
    default => $::default_host,
  }

  $redis_server = $::redis_server ? {
    undef   => undef,
    default => $::redis_server,
  }

  $redis_port = $::redis_port ? {
    undef   => '6379',
    default => $::redis_port,
  }

  $redis_configuration_secure = $::redis_configuration_secure ? {
    undef   => true,
    default => $::redis_configuration_secure,
  }

  $cassandra_host = $::cassandra_host ? {
    undef   => 'localhost',
    default => $::cassandra_host,
  }

  $docker_targetRepository = $::docker_targetRepository ? {
    undef   => undef,
    default => $::docker_targetRepository,
  }

  $jenkins_defaultMaster_name = $::jenkins_defaultMaster_name ? {
    undef   => 'Jenkins',
    default => $::jenkins_defaultMaster_name,
  }

  $jenkins_defaultMaster_baseUrl = $::jenkins_defaultMaster_baseUrl ? {
    undef   => undef,
    default => $::jenkins_defaultMaster_baseUrl,
  }

  $jenkins_defaultMaster_username = $::jenkins_defaultMaster_username ? {
    undef   => undef,
    default => $::jenkins_defaultMaster_username,
  }

  $jenkins_defaultMaster_password = $::jenkins_defaultMaster_password ? {
    undef   => undef,
    default => $::jenkins_defaultMaster_password,
  }

  $travis_enabled = $::travis_enabled ? {
    undef   => false,
    default => $::travis_enabled,
  }

  $travis_defaultMaster_name = $::travis_defaultMaster_name ? {
    undef   => 'ci',
    default => $::travis_defaultMaster_name,
  }

  $travis_defaultMaster_baseUrl = $::travis_defaultMaster_baseUrl ? {
    undef   => 'https://travis-ci.com',
    default => $::travis_defaultMaster_baseUrl,
  }

  $travis_defaultMaster_address = $::travis_defaultMaster_address ? {
    undef   => 'https://api.travis-ci.org',
    default => $::travis_defaultMaster_address,
  }

  $travis_defaultMaster_githubToken = $::travis_defaultMaster_githubToken ? {
    undef   => undef,
    default => $::travis_defaultMaster_githubToken,
  }

  $spectator_webEndpoint_enabled = $::spectator_webEndpoint_enabled ? {
    undef   => true,
    default => $::spectator_webEndpoint_enabled,
  }

  $stackdriver_enabled = $::stackdriver_enabled ? {
    undef   => false,
    default => $::stackdriver_enabled,
  }

  $clouddriver_aws_udf_enabled = $::clouddriver_aws_udf_enabled ? {
    undef   => true,
    default => $::clouddriver_aws_udf_enabled,
  }

  $gate_ldap_url = $::gate_ldap_url ? {
    undef   => undef,
    default => $::gate_ldap_url,
  }

  $gate_ldap_userDnPattern = $::gate_ldap_userDnPattern ? {
    undef   => undef,
    default => $::gate_ldap_userDnPattern,
  }

  $gate_ldap_enabled = $::gate_ldap_enabled ? {
    undef   => true,
    default => $::gate_ldap_enabled,
  }

  $gate_host = $::gate_host ? {
    undef   => '0.0.0.0',
    default => $::gate_host,
  }

  $gate_port = $::gate_port ? {
    undef   => '8084',
    default => $::gate_port,
  }

  $fiat_enabled = $::fiat_enabled ? {
    undef   => true,
    default => $::fiat_enabled,
  }

  $fiat_ldap_url = $::fiat_ldap_url ? {
    undef   => undef,
    default => $::fiat_ldap_url,
  }

  $fiat_userDnPattern = $::fiat_userDnPattern ? {
    undef   => undef,
    default => $::fiat_userDnPattern,
  }

  $fiat_managerDn = $::fiat_managerDn ? {
    undef   => undef,
    default => $::fiat_managerDn,
  }

  $fiat_managerPassword = $::fiat_managerPassword ? {
    undef   => undef,
    default => $::fiat_managerPassword,
  }

  $fiat_groupSearchBase = $::fiat_groupSearchBase ? {
    undef   => undef,
    default => $::fiat_groupSearchBase,
  }

  $fiat_groupSearchFilter = $::fiat_groupSearchFilter ? {
    undef   => undef,
    default => $::fiat_groupSearchFilter,
  }

  $fiat_groupRoleAttributes = $::fiat_groupRoleAttributes ? {
    undef   => undef,
    default => $::fiat_groupRoleAttributes,
  }

  $chaos_enabled = $::chaos_enabled ? {
    undef   => false,
    default => $::chaos_enabled,
  }

  $rosco_configDir = $::rosco_configDir ? {
    undef   => '/opt/rosco/config/packer',
    default => $::rosco_configDir,
  }

  $kubernetes_cluster_name = $::kubernetes_cluster_name ? {
    undef   => undef,
    default => $::kubernetes_cluster_name,
  }

  $kubernetes_api_address = $::kubernetes_api_address ? {
    undef   => undef,
    default => $::kubernetes_api_address,
  }

  $packer_ssh_interface = $::packer_ssh_interface ? {
    undef   => 'private_ip',
    default => $::packer_ssh_interface,
  }

  $packer_vpc_id = $::packer_vpc_id ? {
    undef   => undef,
    default => $::packer_vpc_id,
  }

  $packer_subnet_id = $::packer_subnet_id ? {
    undef   => undef,
    default => $::packer_subnet_id,
  }

  $packer_temporary_security_group_source_cidr = $::packer_temporary_security_group_source_cidr ? {
    undef   => '172.16.0.0/12',
    default => $::packer_temporary_security_group_source_cidr,
  }
}
