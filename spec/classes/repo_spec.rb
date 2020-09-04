require 'spec_helper'

RSpec.describe 'fluentd::repo' do
  test_on = {
    hardwaremodels: ['x86_64'],
    supported_os: [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['6', '7', '8'],
      },
      {
        'operatingsystem'        => 'Ubuntu',
        'operatingsystemrelease' => ['16', '18', '20'],
      },
      {
        'operatingsystem'        => 'Windows',
        'operatingsystemrelease' => ['2012', '2016', '2019'],
      },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      if os_facts[:os]['family'] == 'windows'
        let(:facts) do
          os_facts.merge(
            'choco_install_path' => 'C:/ProgramData/chocolatey',
            'chocolateyversion'  => '0',
          )
        end
        let(:pre_condition) { 'include chocolatey' }
        let(:hklm_instance) { instance_double(Win32::Registry) }

        before(:each) do
          allow_any_instance_of(Win32::Registry).to receive(:[]) # rubocop:disable RSpec/AnyInstance
            .with('ChocolateyInstall')
            .and_return('C:/ProgramData/chocolatey')
        end
      else
        let(:facts) { os_facts }
      end

      if os_facts[:os]['family'] == 'RedHat'
        it do
          is_expected.to contain_yumrepo('treasuredata')
            .with('descr' => 'TreasureData',
                  'baseurl' => "http://packages.treasuredata.com/3/redhat/\$releasever/\$basearch",
                  'enabled' => true,
                  'gpgcheck' => true,
                  'gpgkey' => 'https://packages.treasuredata.com/GPG-KEY-td-agent')
            .that_notifies('Exec[rpmkey]')
        end
        it do
          is_expected.to contain_exec('rpmkey')
            .with('command' => 'rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent',
                  'path' => '/bin:/usr/bin',
                  'refreshonly' => true)
        end
      elsif os_facts[:os]['family'] == 'Debian'
        let(:distro_id) { facts[:lsbdistid].downcase }
        let(:distro_codename) { facts[:lsbdistcodename] }

        it do
          is_expected.to contain_apt__source('treasuredata')
            .with('location' => "http://packages.treasuredata.com/3/#{distro_id}/#{distro_codename}/",
                  'comment' => 'TreasureData',
                  'repos' => 'contrib',
                  'architecture' => 'amd64',
                  'release' => distro_codename,
                  'key' => {
                    'id'     => 'BEE682289B2217F45AF4CC3F901F9177AB97ACBE',
                    'source' => 'https://packages.treasuredata.com/GPG-KEY-td-agent',
                  },
                  'include' => {
                    'src' => false,
                    'deb' => true,
                  })
        end
        it do
          is_expected.to contain_package('td-agent')
            .that_requires('Class[Apt::Update]')
        end
      elsif os_facts[:os]['family'] == 'windows'
        it do
          is_expected.not_to contain_yumrepo('treasuredata')
          is_expected.not_to contain_apt__source('treasuredata')
        end
      else
        it { is_expected.not_to compile }
      end
    end
  end
end
