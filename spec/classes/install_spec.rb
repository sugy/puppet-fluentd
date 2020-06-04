require 'spec_helper'

RSpec.describe 'fluentd::install' do
  test_on = {
    hardwaremodels: ['x86_64'],
    supported_os: [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['6', '7'],
      },
      {
        'operatingsystem'        => 'Ubuntu',
        'operatingsystemrelease' => ['16', '18'],
      },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to contain_package('td-agent') }
      it { is_expected.to contain_file('/etc/td-agent/td-agent.conf') }
      it { is_expected.to contain_file('/etc/td-agent/config.d') }

      case os_facts[:os]['family']
      when 'RedHat'
        it { is_expected.to contain_yumrepo('treasuredata') }
      when 'Debian'
        it { is_expected.to contain_apt__source('treasuredata') }
      end
    end
  end

  context 'with unsupported system' do
    let(:facts) { { osfamily: 'darwin' } }

    it { is_expected.not_to compile }
  end
end
