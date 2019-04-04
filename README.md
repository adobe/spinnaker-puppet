# Spinnaker module

#### Table of Contents
- [Overview](#overview)  
- [Features](#features)  
- [Usage](#usage)  
- [Variables](#variables)
- [Spinnaker RPMs](#spinnaker-rpms)
- [Baking with Rosco](#baking-with-rosco)
- [Environment variables](#environment-variables)
- [Using secrets during Bake](#using-secrets-during-bake)
- [Supported Platforms](#supported-platforms)
- [Known missing features](#known-missing-features)
- [Support](#support)

<a name="overview"/>

#### Overview

Install Spinnaker and all of its dependencies for a fully functional deployment using Puppet on Virtual or Physical machines.

<a name="features"/>

#### Features

The module will install and configure all Spinnaker microservices (others may be added in the future).

For now the module can configure Spinnaker to deploy in AWS and Kubernetes; more can be added

Uses a single Redis endpoint (Elasticache)

Uses LDAP for authentication; can be further expanded to include OKTA and others

Uses Rosco for baking AMIs, the current supported Operating Systems for bake are:
* CentOS6
* CentOS7
* Amazon Linux 2014
* Amazon Linux 2017
* Amazon Linux 2

The aws-ebs.json Packer file is used to bake all Operating Systems; the baked platform is dictated by the source AMI ID used in Spinnaker when baking

The install_packages.sh script is used during the baking process, it handles all aspects of the instance creation (installation and configuration of packages). Note that this may be the most problematic part since it covers our scenarios for the moment. You can further expand on this script and add new features.

<a name="usage"/>

#### Usage

The Puppet module can be invoked as seen in the following example:
```puppet
  class {'spinnaker':
    deck_baseurl               => my_deck_url,
    deck_gateurl               => my_gate_url,
    aws_default_region         => region,
    aws_default_storage_bucket => s3_bucket_name,
    redis_server               => endpoint_of_redis,
    gate_ldap_url              => ldap_url,
    fiat_ldap_url              => ldap_url
  }

```

<a name="variables"/>

#### Variables:

Bellow you will find all variables part of this module that have been used and tested, note that there may be others defined but not currently used.

##### `spinnaker_timezone`
The Spinnaker timezone, defaults to UTC

##### `spinnaker_version`
The Spinnaker app version, defaults to ``installed``

##### `clouddriver_version`
The Clouddriver app version, defaults to ``installed``

##### `deck_version`
The Deck app version, defaults to ``installed``

##### `echo_version`
The Echo app version, defaults to ``installed``

##### `fiat_version`
The Fiat app version, defaults to ``installed``

##### `front50_version`
The Front50 app version, defaults to ``installed``

##### `igor_version`
The Igor app version, defaults to ``installed``

##### `orca_version`
The Orca app version, defaults to ``installed``

##### `rosco_version`
The Rosco app version, defaults to ``installed``

##### `monitoring_daemon_version`
The Monitoring_daemon app version, defaults to ``installed``

##### `clouddriver_aws_accounts`
AWS accounts used by clouddriver, you can have one or more accounts listed as follows:
```yaml
  - name: default
    accountId: account_id
    regions:
      - us-east-1 // region_1
      - us-west-2 // region_2
    lifecycleHooks: // if lifecycle hooks are used
      - defaultResult: 'CONTINUE'
        heartbeatTimeout: 7200
        lifecycleTransition: 'autoscaling:EC2_INSTANCE_TERMINATING' // during the EC2 terminating phase
        notificationTargetARN: 'sns_arn' // SNS topic used for ASG lifecycle hook notifications
        roleARN: 'role_arn' // lifecycle hook assumed role
      - defaultResult: 'CONTINUE'
        heartbeatTimeout: 1200
        lifecycleTransition: 'autoscaling:EC2_INSTANCE_LAUNCHING' // during the EC2 launching phase
        notificationTargetARN: 'sns_arn'
        roleARN: 'role_arn'
  - name: account_2
    ...
```

##### `aws_ami`
The bake template used by Rosco. Once this is configured, the template will be seen in the Spinnaker UI in the ``Base OS`` section of the Bake stage 
```yaml
  - id: Bake-AMI
    shortDescription: "Bake what AMI you want"
    packageType: rpm // what artifacts will be installed during the bake process
    templateFile: aws-ebs.json // the Packer config file, defaults to aws-ebs.json
    regions:
      - region: us-east-1 // AWS region where the bake instance will be deployed
        sourceAmi: ami-id // default AWS source AMI used
```

##### `clouddriver_assumerole`
The default AWS IAM role assumed by Clouddriver

##### `runas_user`
The user under which Spinnaker runs, defaults to ``root``

##### `runas_group`
The group under which Spinnaker runs, defaults to ``root``

##### `aws_enabled`
Weather or not the Spinnaker setup is done in AWS

##### `aws_default_region`
Default AWS region, defaults to ``us-east-1``

##### `aws_primary_credentials`
Default credentials used by Spinnaker, defaults to ``default``

##### `aws_default_iam_role`
Default AWS IAM role used by Spinnaker instances

##### `aws_default_storage_bucket`
Default S3 bucket used by Spinnaker

##### `docker_enabled`
If Docker registries are enabled or not

##### `clouddriver_docker_registries`
Docker registries used by Clouddriver:
```yaml
  - name: docker-test // the name of the Docker registry as will be seen in the Spinnaker UI
    address: docker-test-url // URL endpoint of the Docker registry
    username: username // username used to fetch images from the registry
    password: ENC[password] // password for the username
    repositories:
  - name: docker-production
    address: docker-production-url
    username: username
    password: ENC[password]
    repositories:
```
##### `kubernetes_enabled`
If Spinnaker will be used to deploy charts on Kubernetes

##### `kubernetes_cluster_name`
Kubernetes cluster name as will appear in the Spinnaker UI

##### `kubernetes_api_address`
Kubernetes API endpoint

##### `kubernetes_api_certificate`
Kubernetes API certificate

##### `kubernetes_service_account_name`
Kubernetes service account name

##### `kubernetes_service_account_token`
Kubernetes service account token

##### `clouddriver_kubernetes_accounts`
Accounts used by Clouddriver
```yaml
  - name: kubernetes-account // account name
    docker_registries: // docker registries used by this account
      - docker-test
      - docker-production 
```

##### `kubectl_version`
Kubectl version used by Spinnaker

##### `front50_redis_enabled`
If Front50 uses Redis or not, defaults to ``true``

##### `front50_s3_enabled`
If Front50 uses S3 or not

##### `igor_enabled`
If Igor is enabled or not, defaults to ``false``
  
##### `jenkins_enabled`
If Jenkins is enabled or not, defaults to ``false``

##### `deck_baseurl`
Spinnaker UI url

##### `deck_gateurl`
Spinnaker API url 

##### `deck_domain`
Deck URL domain name

##### `deck_auth_enabled`
If Deck authentication is enabled

##### `echo_port`
Default echo port, defaults to ``8009``

##### `echo_cassandra_enabled`
If Cassandra is enabled or not

##### `echo_inMemory_enabled`
Echo inMemory trigger 

##### `echo_cron_enabled`
If Echo crons are enabled or not

##### `echo_mail_enabled`
If Echo mails are enabled or not

##### `echo_mail_host`
Echo mail sending host

##### `echo_mail_fromAddress`
Echo mail from to address

##### `echo_hipchat_enabled`
Echo hipchat trigger

##### `echo_hipchat_url`
Echo hipchat endpoint

##### `echo_hipchat_token`
Echo hipchat API token

##### `echo_hipchat_botName`
Echo hipchat bot name

##### `echo_sms_enabled`
Echo sms trigger

##### `echo_sms_account`
Echo sms account name

##### `echo_sms_token`
Echo sms token

##### `echo_sms_from`
Echo sms from to entity

##### `echo_slack_enabled`
Echo Slack trigger

##### `echo_slack_token`
Echo Slack token

##### `echo_slack_botname`
Echo Slack bot name

##### `default_protocol`
Spinnaker default protocol

##### `default_host`
Spinnaker default host

##### `redis_server`
Redis server hostname

##### `redis_port`
Redis server port

##### `redis_configuration_secure`
Redis trigger secure config

##### `docker_targetRepository`
Docker repository

##### `gate_ldap_url`
Gate LDAP endpoint

##### `gate_ldap_userDnPattern`
Gate LDAP user pattern

##### `gate_port`
Gate port

##### `gate_host`
Gate hostname

##### `gate_ldap_enabled`
Gate LDAP integration trigger

##### `fiat_enabled`
Fiat trigger

##### `fiat_ldap_url`
Echo LDAP endpoint

##### `fiat_userDnPattern`
Fiat LDAP user filtering 

##### `fiat_managerDn`
Fiat LDAP service account

##### `fiat_managerPassword`
Fiat LDAP service account password

##### `fiat_groupSearchBase`
Fiat LDAP group filtering

##### `fiat_groupSearchFilter`
Fiat LDAP group search filter

##### `fiat_groupRoleAttributes`
Fiat LDAP group role attributes

##### `chaos_enabled`
Chaos trigger

##### `rosco_configDir`
Rosco configuration directory

##### `monitoring_gateUser`
Rosco monitoring username

##### `monitoring_gatePassword`
Rosco monitoring password

##### `packer_ssh_interface`
Packer interface used for ssh, defaults to ``private_ip ``

##### `packer_vpc_id`
Rosco VPC id where the Packer instance will be bootstrapped

##### `packer_subnet_id`
Rosco subnet ID where the Packer instance will be bootstrapped

##### `packer_temporary_security_group_source_cidr`
Rosco the source CIDR block from where ssh connections will be allowed, defaults to ``172.16.0.0/12``

<a name="spinnaker-rpms"/>

#### Spinnaker RPMs

We are currently creating our own Spinnaker RPMs which will be published (hopefully) soon on a public repository.

<a name="baking-with-rosco"/>

#### Baking with Rosco

You can use Spinnaker to bake AMIs for different Operating Systems, you can perform such operation during the "Bake" stage of your pipeline.

Behind the scenes, Rosco uses Packer for baking any AMI. A multi-layered approach can be used in which you bake a "Base" AMI then build other "Application specific" AMIs on top. 

This deployment uses a single Packer configuration file (`aws-ebs.json`) for baking.
```bash
bootstrap_env_1..10 # environment variables used during the bootstrap process
bootstrap_secrets_1..10 # secrets extracted during the bake process
bake_env_1 .. 10 # environment variables used during the bake process
aws_iam_instance_profile # the instance profile used by the Packer machine
ami_os # the OS of the baked instance
ami_name # the name of the AMI
upgrade # if yum upgrade is needed before baking
packages # list of packages in the order of install

```

The `install_packages.sh` script uses all the logic for baking an AMI. There is a brief description of the script's purpose in its header.

<a name="environment-variables"/>

#### Environment variables

Are passed in the "Bake" stage as key/value entries in the "Extended Attributes" section.

You are probably wondering why there are `bootstrap_env_*`, `bootstrap_secrets_*` and `bake_env_*` variables used in the install_packages script. 

What's important to note is that by default, the `bootstrap_env` and `bootstrap_secrets` variables are persisted on disk after the AMI has been created. 

These variables can be used by applications running on the actual production instance once deployed. 

This is our way of creating semi-immutable EC2 instances. Every change in the instance results in a new bake and deploy operation.

You can decide to stop these variables from being written on the disk by using the `persist_variables` trigger.

The `bake_env` variables are only used during the bake process and are never persisted to disk.

All these environment variables are treated as lists and each one can have multiple values separated by the comma character, as follows:
```bash
bootstrap_env_1 = script_variable1=test
bootstrap_env_2 = script_variable2=test2,script_variable3=test3

bake_env_1 = var1=false,var2=test

bootstrap_secrets_1 = mysecret1=ssm://MY_SECRET1,mysecret1=ssm://MY_SECRET2
bootstrap_secrets_2 = mysecret3=ssm://MY_SECRET3
```

<a name="using-secrets-during-bake"/>

#### Using secrets during Bake

The bootstrap_secrets_* variables values are prefixed by the "secret provider" (e.g. ssm, vault). 

The install_packages script will try to fetch those secrets and use them (if needed) during the bake or the startup phase (if secrets are persisted on disk).

In the following example, a variable named repository_password is defined in the "Extended Attributes" section of the bake stage:
```bash
  repository_password=ssm://REPOSITORY_PASSWORD
```

<a name="supported-platforms"/>

#### Supported Platforms

The setup has been deployed so far in AWS on EC2 instances.
The module has been tested on the following operating systems.

* CentOS 6
* CentOS 7

Testing and patches for other platforms are welcomed.

<a name="known-missing-features"/>

#### Known missing features

There are currently no initd or systemd files for starting the Spinnaker daemons, this is why the service.pp file is empty.

Spinnaker microservices are started by a script located in `/opt/spinnaker/bin/start_spinnaker.sh` and has been removed
completely in newer versions.

No other cloud providers have been added nor tested in the module.

Extracting secrets from Vault has not been implemented yet.

<a name="support"/>

### Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.
GitHub [repository](https://github.com/adobe/spinnaker-puppet)

### Licensing

This project is licensed under the Apache V2 License. See [LICENSE](LICENSE) for more information.
