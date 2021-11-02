# Common fluentd parameters
class fluentd::params {
  $repo_name = 'treasuredata'
  $repo_desc = 'TreasureData'
  $repo_version = '4'

  case $facts['os']['family'] {
    'RedHat': {
      $config_file = '/etc/td-agent/td-agent.conf'
      $config_file_mode = '0640'
      $config_path = '/etc/td-agent/config.d'
      $config_path_mode = '0750'
      $config_owner = 'td-agent'
      $config_group = 'td-agent'
      $package_provider = undef
      $repo_manage = true
      $service_name = 'td-agent'
    }
    'Debian': {
      $config_file = '/etc/td-agent/td-agent.conf'
      $config_file_mode = '0640'
      $config_path = '/etc/td-agent/config.d'
      $config_path_mode = '0750'
      $config_owner = 'td-agent'
      $config_group = 'td-agent'
      $package_provider = undef
      $repo_manage = true
      $service_name = 'td-agent'
    }
    'windows': {
      $config_file = 'C:/opt/td-agent/etc/td-agent/td-agent.conf'
      $config_file_mode = undef
      $config_path = 'C:/opt/td-agent/etc/td-agent/config.d'
      $config_path_mode = undef
      $config_owner = 'Administrator'
      $config_group = 'Administrator'
      $package_provider = 'chocolatey'
      # there is no public repo for windows, we assume that the user has already
      # setup the Chocolatey sources correctly
      $repo_manage = false
      # windows service uses a different name
      $service_name = 'fluentdwinsvc'
    }
    default: {
      fail("Unsupported osfamily ${facts['os']['family']}")
    }
  }

  $repo_enabled = true
  $repo_gpgcheck = true
  $repo_gpgkey = 'https://packages.treasuredata.com/GPG-KEY-td-agent'
  $repo_gpgkeyid = 'BEE682289B2217F45AF4CC3F901F9177AB97ACBE'

  $package_name = 'td-agent'
  $package_ensure = present

  $service_ensure = running
  $service_enable = true
  $service_manage = true

  $configs = {}

  $plugins = {}

  $purge_config_dir = true
}
