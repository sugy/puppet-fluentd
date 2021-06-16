## Development

## 2021-06-16 - Release v1.1.1

- Fixed bug in error handling if `tdaget` provider.

  Contributed by Brendan Harley (@skylt)

## 2020-12-17 - Release v1.1.0

- Added support for Amazon linux.

  Contributed by Luc Duriez (@lduriez)

## 2020-12-17 - Release v1.0.2

- Fix `tdagent` provider for `package` to implement proper lazy delay of its commands
  and pick up the correct command path once `td-agent` is properly installed.
  This fixes a bug where the `tdagent` provider for `package` was not usable during
  the Puppet run when `td-agent` is installed.

  Contributed by Nick Maludy (@nmaludy)

- Removed fix put in place in v1.0.1 for RHE/CentOS $releasever workaround.
  Treasure Data has fixed the problem on their repo and "7Server" now redirects properly.

  Contributed by Nick Maludy (@nmaludy)

## 2020-11-13 - Release v1.0.1

- Fix td-agent YUM repo URL for v4 on RHEL/CentOS not behaving correctly when $releasever
  is something like "7Server", instead it expect it to be "7"

  Contributed by Nick Maludy (@nmaludy)

## 2020-11-13 - Release v1.0.0

- Change default fluentd/td-agent version from `v3` to `v4`

  Contributed by Nick Maludy (@nmaludy)

## 2020-09-03 - Release v0.12.4

- Fixed a bug in `fluentd_windows_service` where the service description was using the wrong flag.

  Contributed by Nick Maludy (@nmaludy)

## 2020-09-03 - Release v0.12.3

- Fixed a bug in `fluentd_windows_service` where the service description was being set to
  the wrong field.

  Contributed by Nick Maludy (@nmaludy)

- Fixed a bug in `fluentd::repo` on Debian/Ubuntu where the repo url was being setup incorrectly.

  Contributed by Nick Maludy (@nmaludy)

## 2020-06-25 - Release v0.12.2

- Fixed a bug in `fluentd_windows_service` that wasn't properly checking registry key didn't exist.

  Contributed by Nick Maludy (@nmaludy)


## 2020-06-25 - Release v0.12.1

- Fixed a bug in `fluentd_windows_service` that wasn't properly checking exception messages when the fluentd service didn't exist.

  Contributed by Nick Maludy (@nmaludy)

## 2020-06-16 - Release v0.12.0

- Converted the Windows Service regsitration from an `exec` resource into a Resource API resource.

  Contributed by Nick Maludy (@nmaludy)

## 2020-06-16 - Release v0.11.0

- Convert module to PDK
- Added support for installing on Windows

  Contributed by Nick Maludy (@nmaludy)

## 2017-09-01 - Release v. 0.10.0

- Update version requirements for `puppetlabs/stdlib`
- Update version requirements for `puppetlabs/apt`

## 2017-01-28 - Release v. 0.9.0

 - Use Puppet 4 data types
 - Run apt update before installing packages

## 2016-11-06 - Release v. 0.8.0

 - Add param `plugins`
 - Add param `configs`
 - Remove deprecated params `plugin_names`, `plugin_ensure`, `plugin_source`,
   `plugin_provider`, `plugin_install_options`

## 2016-10-13 - Release v. 0.7.0

 - Add param `service_provider` (@larsks)
 - Plugin version can be specified (@denis-sorokin)
 - Add params `config_path` and `plugin_provider` (@paramite)
 - Add params `config_owner` and `config_group` (@MartinMeinhold)
 - Deprecate param `plugin_names`
 - Deprecate param `plugin_ensure`
 - Deprecate param `plugin_source`
 - Deprecate param `plugin_provider`
 - Deprecate param `plugin_install_options`

## 2016-04-20 - Release v. 0.6.1

 - Remove rubygems package
 - Fix the issue with Ruby load path

## 2016-04-11 - Release v. 0.6.0

 - Rework config generation

## 2016-03-23 - Release v. 0.5.1

 - Use fully qualified param names (@tosmi)

## 2016-02-20 - Release v. 0.5.0

 - Add param `plugin_install_options` (@dembaca)

## 2016-02-03 - Release v. 0.4.0

 - Support CentOS 6

## 2016-01-22 - Release v. 0.3.2

 - Purge unmanaged config files
 - Manage td-agent.conf file with a fully qualified path (@EmilienM)
 - Fix the issue with td-agent service being enabled on each run on EL7

## 2015-12-02 - Release v. 0.3.1

 - Add param `repo_desc`

## 2015-10-28 - Release v. 0.3.0

 - Remove class `fluentd::config`
 - Add defined type `fluentd::config`
 - Add defined type `fluentd::plugin`

## 2015-10-22 - Release v. 0.2.0

 - Add param `service_manage`
 - Add param `repo_gpgkeyid`
 - Add param `repo_install`
 - Add param `plugin_source`
 - Rename param `repo_baseurl` to `repo_url`
 - Remove param `config_template`
 - Param validation
 - Support Ubuntu 14.04
 - Support Debian 7.8
 - Support nested config tags

## 2015-10-19 - Release v. 0.1.0

 - Initial release
