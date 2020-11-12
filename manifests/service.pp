# Resource for managing the FluentD service
class fluentd::service inherits fluentd {
  if $fluentd::service_manage {
    # On Windows
    # Fluentd v3 and older required us to self-register the Windows services
    # In Fluentd v4+, the Windows service is registered as part of the MSI installer
    if ($facts['os']['family'] == 'windows' and versioncmp($fluentd::repo_version, '3') <= 0) {
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
