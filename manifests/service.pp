# Resource for managing the FluentD service
class fluentd::service inherits fluentd {
  if $fluentd::service_manage {
    if $facts['os']['family'] == 'windows' {
      fluentd_windows_service { $fluentd::service_name:
        ensure    => present,
        command   => 'C:/opt/td-agent/embedded/bin/fluentd.bat',
        subscribe => Package[$fluentd::package_name],
        notify    => Service[$fluentd::service_name],
      }
    }

    service { $fluentd::service_name:
      ensure => $fluentd::service_ensure,
      enable => $fluentd::service_enable,
    }
  }
}
