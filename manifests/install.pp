# Installs FluentD
class fluentd::install inherits fluentd {
  contain fluentd::repo

  package { $fluentd::package_name:
    ensure   => $fluentd::package_ensure,
    provider => $fluentd::package_provider,
    require  => Class['fluentd::repo'],
  }

  -> file { $fluentd::config_path:
    ensure  => directory,
    owner   => $fluentd::config_owner,
    group   => $fluentd::config_group,
    mode    => $fluentd::config_path_mode,
    recurse => true,
    force   => true,
    purge   => true,
  }

  -> file { $fluentd::config_file:
    ensure => file,
    source => 'puppet:///modules/fluentd/td-agent.conf',
    owner  => $fluentd::config_owner,
    group  => $fluentd::config_group,
    mode   => $fluentd::config_file_mode,
  }
}
