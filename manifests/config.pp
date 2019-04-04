#Copyright 2019 Adobe. All rights reserved.
#This file is licensed to you under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License. You may obtain a copy
#of the License at http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software distributed under
#the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
#OF ANY KIND, either express or implied. See the License for the specific language
#governing permissions and limitations under the License.

class spinnaker::config () {

  File {
    owner   => $::spinnaker::runas_user,
    group   => $::spinnaker::runas_group,
    mode    => '0600'
  }

  file { '/opt/spinnaker/config/spinnaker-local.yml':
    ensure  => file,
    content => template('spinnaker/spinnaker-local.yml.erb'),
  }

  file { '/opt/spinnaker/config/clouddriver-local.yml':
    ensure  => file,
    content => template('spinnaker/clouddriver-local.yml.erb'),
  }

  file { '/opt/spinnaker/config/gate-local.yml':
    ensure  => file,
    content => template('spinnaker/gate-local.yml.erb'),
  }

  file { '/opt/spinnaker/config/fiat-local.yml':
    ensure  => file,
    content => template('spinnaker/fiat-local.yml.erb'),
  }

  file { '/opt/spinnaker/config/front50.yml':
    ensure  => file,
    content => template('spinnaker/front50.yml.erb'),
  }

  file { '/opt/rosco/config/rosco.yml':
    ensure  => file,
    content => template('spinnaker/rosco.yml.erb'),
  }

  file { '/opt/spinnaker-monitoring/registry/gate.yml':
    ensure  => file,
    content => template('spinnaker/monitoring-gate.yml.erb'),
    owner   => spinnaker,
    group   => spinnaker,
  }

  file { '/opt/rosco/config/packer/aws-ebs.json':
    ensure  => file,
    content => template('spinnaker/aws-ebs.json.erb'),
  }

  file { '/opt/rosco/config/packer/install_packages.sh':
    ensure => file,
    mode   => '0750',
    source => "puppet:///modules/${module_name}/install_packages.sh"
  }

  exec { 'clean-useless-packer':
    command => 'unlink /usr/sbin/packer',
    onlyif  => 'stat /usr/sbin/packer',
    path    => '/bin:/usr/bin',
  }

  if $::spinnaker::kubernetes_enabled {
    file {"/${::spinnaker::runas_user}/.kube":
      ensure => directory,
    }

    file {"/${::spinnaker::runas_user}/.kube/config":
      ensure  => file,
      mode    => '0600',
      content => template('spinnaker/kubectl_spinnaker_config.erb'),
    }
  }
}
