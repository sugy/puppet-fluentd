# Resource for populating a FluentD config
define fluentd::config($config) {
  include fluentd

  file { "${fluentd::config_path}/${title}":
    ensure  => file,
    content => fluent_config($config),
    require => Class['Fluentd::Install'],
    notify  => Class['Fluentd::Service'],
  }
}
