# Configures the FluentD repo
class fluentd::repo inherits fluentd {
  if $fluentd::repo_manage {
    $version = $fluentd::repo_version
    case $facts['os']['family'] {
      'RedHat': {
        $repo_url = pick($fluentd::repo_url,
                          "http://packages.treasuredata.com/${version}/redhat/\$releasever/\$basearch")
        yumrepo { $fluentd::repo_name:
          descr    => $fluentd::repo_desc,
          baseurl  => $repo_url,
          enabled  => $fluentd::repo_enabled,
          gpgcheck => $fluentd::repo_gpgcheck,
          gpgkey   => $fluentd::repo_gpgkey,
          notify   => Exec['rpmkey'],
        }

        exec { 'rpmkey':
          command     => "rpm --import ${fluentd::repo_gpgkey}",
          path        => '/bin:/usr/bin',
          refreshonly => true,
        }
      }
      'Debian': {
        $distro_id = downcase($facts['lsbdistid'])
        $distro_codename = $facts['lsbdistcodename']
        $repo_url = pick($fluentd::repo_url,
                          "http://packages.treasuredata.com/${version}/${distro_id}/${distro_codename}/")

        apt::source { $fluentd::repo_name:
          location     => $repo_url,
          comment      => $fluentd::repo_desc,
          repos        => 'contrib',
          architecture => 'amd64',
          release      => $distro_codename,
          key          => {
            id     => $fluentd::repo_gpgkeyid,
            source => $fluentd::repo_gpgkey,
          },
          include      => {
            'src' => false,
            'deb' => true,
          },
        }

        Class['Apt::Update'] -> Package[$fluentd::package_name]
      }
      default: {
        fail("Unsupported os family: ${facts['osfamily']}")
      }
    }
  }
}
