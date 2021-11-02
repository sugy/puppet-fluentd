require 'spec_helper'

RSpec.describe 'fluentd::install' do
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
      let(:facts) { os_facts }

      it { is_expected.to contain_package('td-agent') }

      if os_facts[:os]['family'] == 'windows'
        it do
          is_expected.to contain_file('C:/opt/td-agent/etc/td-agent/td-agent.conf')
            .with('ensure'  => 'file',
                  'source'  => 'puppet:///modules/fluentd/td-agent.conf',
                  'owner'   => 'Administrator',
                  'group'   => 'Administrator',
                  'mode'    => nil)
        end
        it do
          is_expected.to contain_file('C:/opt/td-agent/etc/td-agent/config.d')
            .with('ensure'  => 'directory',
                  'owner'   => 'Administrator',
                  'group'   => 'Administrator',
                  'mode'    => nil,
                  'recurse' => false,
                  'force'   => true,
                  'purge'   => false)
        end
      else
        it do
          is_expected.to contain_file('/etc/td-agent/td-agent.conf')
            .with('ensure'  => 'file',
                  'source'  => 'puppet:///modules/fluentd/td-agent.conf',
                  'owner'   => 'td-agent',
                  'group'   => 'td-agent',
                  'mode'    => '0640')
        end
        it do
          is_expected.to contain_file('/etc/td-agent/config.d')
            .with('ensure'  => 'directory',
                  'owner'   => 'td-agent',
                  'group'   => 'td-agent',
                  'mode'    => '0750',
                  'recurse' => false,
                  'force'   => true,
                  'purge'   => false)
        end

        case os_facts[:os]['family']
        when 'RedHat'
          it { is_expected.to contain_yumrepo('treasuredata') }
        when 'Debian'
          it { is_expected.to contain_apt__source('treasuredata') }
        end
      end
    end
  end

  context 'with unsupported system' do
    let(:facts) { { osfamily: 'darwin' } }

    it { is_expected.not_to compile }
  end
end
