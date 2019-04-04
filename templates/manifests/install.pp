#Copyright 2019 Adobe. All rights reserved.
#This file is licensed to you under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License. You may obtain a copy
#of the License at http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software distributed under
#the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
#OF ANY KIND, either express or implied. See the License for the specific language
#governing permissions and limitations under the License.

class spinnaker::install () {

  package { 'spinnaker':
    ensure  => $::spinnaker::version
  }

  package { 'spinnaker-clouddriver':
    ensure  => $::spinnaker::clouddriver_version
  }

  package { 'spinnaker-deck':
    ensure  => $::spinnaker::deck_version
  }

  package { 'spinnaker-echo':
    ensure  => $::spinnaker::echo_version
  }

  package { 'spinnaker-fiat':
    ensure  => $::spinnaker::fiat_version
  }

  package { 'spinnaker-front50':
    ensure  => $::spinnaker::front50_version
  }

  package { 'spinnaker-igor':
    ensure  => $::spinnaker::igor_version
  }

  package { 'spinnaker-orca':
    ensure  => $::spinnaker::orca_version
  }

  package { 'spinnaker-rosco':
    ensure  => $::spinnaker::rosco_version
  }

  package { 'spinnaker-monitoring-daemon':
    ensure  => $::spinnaker::monitoring_daemon_version
  }

  package { 'kubectl':
    ensure  => $::spinnaker::kubectl_version
  }
}
