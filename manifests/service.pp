# Resource for managing the FluentD service
class fluentd::service inherits fluentd {
  if $fluentd::service_manage {
    if $facts['os']['family'] == 'windows' {
      # subscribe to changes in the package,
      # the fluentd service has a hard coded path with the fluentd gem version in it
      # when the new package gets installed, we need to unregister the service with
      # the old path and register with the service with the new path
      # this first resource handles unregistering the service only when the package changes.
      # the second resource handles registering the new service
      exec { 'fluentd - delete stale service':
        command     => "sc.exe delete ${fluentd::service_name}",
        path        => ['C:\Windows\System32'],
        unless      => "sc.exe query ${fluentd::service_name}",
        refreshonly => true,
        subscribe   => Package[$fluentd::package_name],
      }
      ~> exec { 'fluentd - register service':
        command => "fluentd --reg-winsvc i --winsvc-name ${fluentd::service_name} --reg-winsvc-auto-start --reg-winsvc-fluentdopt '-c C:/opt/td-agent/etc/td-agent/td-agent.conf -o C:/opt/td-agent/td-agent.log'", # lint:ignore:140chars
        cwd     => 'C:\opt\td-agent\embedded\bin',
        path    => ['C:\opt\td-agent\embedded\bin', 'C:\Windows\System32'],
        unless  => "sc.exe query ${fluentd::service_name}",
        require => Package[$fluentd::package_name],
        notify  => Service[$fluentd::service_name],
      }
    }

    service { $fluentd::service_name:
      ensure => $fluentd::service_ensure,
      enable => $fluentd::service_enable,
    }
  }
}
