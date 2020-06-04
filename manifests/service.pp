# Resource for managing the FluentD service
class fluentd::service inherits fluentd {
  if $fluentd::service_manage {
    service { $fluentd::service_name:
      ensure => $fluentd::service_ensure,
      enable => $fluentd::service_enable,
    }
  }
}
