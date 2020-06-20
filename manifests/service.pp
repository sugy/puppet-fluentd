# Resource for managing the FluentD service
class fluentd::service inherits fluentd {
  if $fluentd::service_manage {
    if $facts['os']['family'] == 'windows' {
      exec { 'fluentd - register service':
        command   => "fluentd.bat --reg-winsvc i --winsvc-name ${fluentd::service_name} --reg-winsvc-auto-start", # lint:ignore:140chars
        path      => ['C:/opt/td-agent/embedded/bin', 'C:/Windows/System32'],
        unless    => "sc.exe query ${fluentd::service_name}",
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
