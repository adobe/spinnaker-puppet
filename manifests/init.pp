#Copyright 2019 Adobe. All rights reserved.
#This file is licensed to you under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License. You may obtain a copy
#of the License at http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software distributed under
#the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
#OF ANY KIND, either express or implied. See the License for the specific language
#governing permissions and limitations under the License.

class spinnaker(

  $spinnaker_timezone                          = $spinnaker::params::spinnaker_timezone,
  $spinnaker_version                           = $spinnaker::params::spinnaker_version,
  $clouddriver_version                         = $spinnaker::params::clouddriver_version,
  $deck_version                                = $spinnaker::params::deck_version,
  $echo_version                                = $spinnaker::params::echo_version,
  $fiat_version                                = $spinnaker::params::fiat_version,
  $front50_version                             = $spinnaker::params::front50_version,
  $igor_version                                = $spinnaker::params::igor_version,
  $orca_version                                = $spinnaker::params::orca_version,
  $rosco_version                               = $spinnaker::params::rosco_version,
  $monitoring_daemon_version                   = $spinnaker::params::monitoring_daemon_version,
  $clouddriver_aws_accounts                    = $spinnaker::params::clouddriver_aws_accounts,
  $aws_ami                                     = $spinnaker::params::aws_ami,
  $clouddriver_assumerole                      = $spinnaker::params::clouddriver_assumerole,
  $runas_user                                  = $spinnaker::params::runas_user,
  $runas_group                                 = $spinnaker::params::runas_group,
  $aws_enabled                                 = $spinnaker::params::aws_enabled,
  $aws_default_region                          = $spinnaker::params::aws_default_region,
  $aws_primary_credentials                     = $spinnaker::params::aws_primary_credentials,
  $aws_default_iam_role                        = $spinnaker::params::aws_default_iam_role,
  $aws_default_storage_bucket                  = $spinnaker::params::aws_default_storage_bucket,
  $docker_enabled                              = $spinnaker::params::docker_enabled,
  $clouddriver_docker_registries               = $spinnaker::params::clouddriver_docker_registries,
  $kubernetes_enabled                          = $spinnaker::params::kubernetes_enabled,
  $kubernetes_cluster_name                     = $spinnaker::params::kubernetes_cluster_name,
  $kubernetes_api_address                      = $spinnaker::params::kubernetes_api_address,
  $kubernetes_api_certificate                  = $spinnaker::params::kubernetes_api_certificate,
  $kubernetes_service_account_name             = $spinnaker::params::kubernetes_service_account_name,
  $kubernetes_service_account_token            = $spinnaker::params::kubernetes_service_account_token,
  $clouddriver_kubernetes_accounts             = $spinnaker::params::clouddriver_kubernetes_accounts,
  $kubectl_version                             = $spinnaker::params::kubectl_version,
  $front50_cassandra_enabled                   = $spinnaker::params::front50_cassandra_enabled,
  $front50_redis_enabled                       = $spinnaker::params::front50_redis_enabled,
  $front50_s3_enabled                          = $spinnaker::params::front50_s3_enabled,
  $front50_gcs_enabled                         = $spinnaker::params::front50_gcs_enabled,
  $front50_azs_enabled                         = $spinnaker::params::front50_azs_enabled,
  $front50_azs_storageAccountName              = $spinnaker::params::front50_azs_storageAccountName,
  $front50_azs_storageAccountKey               = $spinnaker::params::front50_azs_storageAccountKey,
  $front50_azs_storageContainerName            = $spinnaker::params::front50_azs_storageContainerName,
  $igor_enabled                                = $spinnaker::params::igor_enabled,
  $jenkins_enabled                             = $spinnaker::params::jenkins_enabled,
  $deck_baseurl                                = $spinnaker::params::deck_baseurl,
  $deck_gateurl                                = $spinnaker::params::deck_gateurl,
  $deck_domain                                 = $spinnaker::params::deck_domain,
  $deck_auth_enabled                           = $spinnaker::params::deck_auth_enabled,
  $echo_port                                   = $spinnaker::params::echo_port,
  $echo_cassandra_enabled                      = $spinnaker::params::echo_cassandra_enabled,
  $echo_inMemory_enabled                       = $spinnaker::params::echo_inMemory_enabled,
  $echo_cron_enabled                           = $spinnaker::params::echo_cron_enabled,
  $echo_mail_enabled                           = $spinnaker::params::echo_mail_enabled,
  $echo_mail_host                              = $spinnaker::params::echo_mail_host,
  $echo_mail_fromAddress                       = $spinnaker::params::echo_mail_fromAddress,
  $echo_hipchat_enabled                        = $spinnaker::params::echo_hipchat_enabled,
  $echo_hipchat_url                            = $spinnaker::params::echo_hipchat_url,
  $echo_hipchat_token                          = $spinnaker::params::echo_hipchat_token,
  $echo_hipchat_botName                        = $spinnaker::params::echo_hipchat_botName,
  $echo_sms_enabled                            = $spinnaker::params::echo_sms_enabled,
  $echo_sms_account                            = $spinnaker::params::echo_sms_account,
  $echo_sms_token                              = $spinnaker::params::echo_sms_token,
  $echo_sms_from                               = $spinnaker::params::echo_sms_from,
  $echo_slack_enabled                          = $spinnaker::params::echo_slack_enabled,
  $echo_slack_token                            = $spinnaker::params::echo_slack_token,
  $echo_slack_botname                          = $spinnaker::params::echo_slack_botname,
  $default_protocol                            = $spinnaker::params::default_protocol,
  $default_host                                = $spinnaker::params::default_host,
  $redis_server                                = $spinnaker::params::redis_server,
  $redis_port                                  = $spinnaker::params::redis_port,
  $redis_configuration_secure                  = $spinnaker::params::redis_configuration_secure,
  $cassandra_host                              = $spinnaker::params::cassandra_host,
  $docker_targetRepository                     = $spinnaker::params::docker_targetRepository,
  $jenkins_defaultMaster_name                  = $spinnaker::params::jenkins_defaultMaster_name,
  $jenkins_defaultMaster_baseUrl               = $spinnaker::params::jenkins_defaultMaster_baseUrl,
  $jenkins_defaultMaster_username              = $spinnaker::params::jenkins_defaultMaster_username,
  $jenkins_defaultMaster_password              = $spinnaker::params::jenkins_defaultMaster_password,
  $travis_enabled                              = $spinnaker::params::travis_enabled,
  $travis_defaultMaster_name                   = $spinnaker::params::travis_defaultMaster_name,
  $travis_defaultMaster_baseUrl                = $spinnaker::params::travis_defaultMaster_baseUrl,
  $travis_defaultMaster_address                = $spinnaker::params::travis_defaultMaster_address,
  $travis_defaultMaster_githubToken            = $spinnaker::params::travis_defaultMaster_githubToken,
  $spectator_webEndpoint_enabled               = $spinnaker::params::spectator_webEndpoint_enabled,
  $stackdriver_enabled                         = $spinnaker::params::stackdriver_enabled,
  $clouddriver_aws_udf_enabled                 = $spinnaker::params::clouddriver_aws_udf_enabled,
  $gate_ldap_url                               = $spinnaker::params::gate_ldap_url,
  $gate_ldap_userDnPattern                     = $spinnaker::params::gate_ldap_userDnPattern,
  $gate_ldap_enabled                           = $spinnaker::params::gate_ldap_enabled,
  $gate_host                                   = $spinnaker::params::gate_host,
  $gate_port                                   = $spinnaker::params::gate_port,
  $fiat_enabled                                = $spinnaker::params::fiat_enabled,
  $fiat_ldap_url                               = $spinnaker::params::fiat_ldap_url,
  $fiat_userDnPattern                          = $spinnaker::params::fiat_userDnPattern,
  $fiat_managerDn                              = $spinnaker::params::fiat_managerDn,
  $fiat_managerPassword                        = $spinnaker::params::fiat_managerPassword,
  $fiat_groupSearchBase                        = $spinnaker::params::fiat_groupSearchBase,
  $fiat_groupSearchFilter                      = $spinnaker::params::fiat_groupSearchFilter,
  $fiat_groupRoleAttributes                    = $spinnaker::params::fiat_groupRoleAttributes,
  $chaos_enabled                               = $spinnaker::params::chaos_enabled,
  $rosco_configDir                             = $spinnaker::params::rosco_configDir,
  $monitoring_gateUser                         = $spinnaker::params::monitoring_gateUser,
  $monitoring_gatePassword                     = $spinnaker::params::monitoring_gatePassword,
  $packer_ssh_interface                        = $spinnaker::params::packer_ssh_interface,
  $packer_vpc_id                               = $spinnaker::params::packer_vpc_id,
  $packer_subnet_id                            = $spinnaker::params::packer_subnet_id,
  $packer_temporary_security_group_source_cidr = $spinnaker::params::packer_temporary_security_group_source_cidr,
) inherits spinnaker::params { #lint:ignore:class_inherits_from_params_class

  validate_array($clouddriver_aws_accounts)

  contain spinnaker::install
  contain spinnaker::config
  contain spinnaker::service

  Class['spinnaker::install']
  -> Class['spinnaker::config']
  -> Class['spinnaker::service']

}
