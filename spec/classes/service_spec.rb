require 'spec_helper'

RSpec.describe 'fluentd::service' do
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

      case os_facts[:os]['family']
      when 'RedHat'
        it { is_expected.to contain_service('td-agent').with(provider: 'redhat') }
      when 'Debian'
        it { is_expected.to contain_service('td-agent').without(:provider) }
      end
    end
  end
end
