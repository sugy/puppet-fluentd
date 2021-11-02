# Class fluentd install, configures and manages the fluentd (td-agent)
# service.
#
class fluentd (
  Boolean $repo_manage = $fluentd::params::repo_manage,
  String $repo_name = $fluentd::params::repo_name,
  String $repo_desc = $fluentd::params::repo_desc,
  String $repo_version = $fluentd::params::repo_version,
  Optional[Stdlib::Httpurl] $repo_url = undef,
  Boolean $repo_enabled = $fluentd::params::repo_enabled,
  Boolean $repo_gpgcheck = $fluentd::params::repo_gpgcheck,
  Stdlib::Httpurl $repo_gpgkey = $fluentd::params::repo_gpgkey,
  String $repo_gpgkeyid = $fluentd::params::repo_gpgkeyid,
  String $package_name = $fluentd::params::package_name,
  String $package_ensure = $fluentd::params::package_ensure,
  Optional[String] $package_provider = $fluentd::params::package_provider,
  String $service_name = $fluentd::params::service_name,
  String $service_ensure = $fluentd::params::service_ensure,
  Boolean $service_enable = $fluentd::params::service_enable,
  Boolean $service_manage = $fluentd::params::service_manage,
  Stdlib::Absolutepath $config_file = $fluentd::params::config_file,
  Optional[Stdlib::Filemode] $config_file_mode = $fluentd::params::config_file_mode,
  Stdlib::Absolutepath $config_path = $fluentd::params::config_path,
  Optional[Stdlib::Filemode] $config_path_mode = $fluentd::params::config_path_mode,
  String $config_owner = $fluentd::params::config_owner,
  String $config_group = $fluentd::params::config_group,
  Hash $configs = $fluentd::params::configs,
  Hash $plugins = $fluentd::params::plugins,
  Boolean $purge_config_dir = $fluentd::params::purge_config_dir
) inherits fluentd::params {
  contain fluentd::install
  contain fluentd::service

  Class['fluentd::install'] -> Class['fluentd::service']

  create_resources('fluentd::plugin', $plugins)
  create_resources('fluentd::config', $configs)
}
