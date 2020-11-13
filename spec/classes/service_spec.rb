require 'spec_helper'

RSpec.describe 'fluentd::service' do
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

      if os_facts[:os]['family'] == 'windows'
        # different service name on windows
        it { is_expected.to contain_service('fluentdwinsvc').without(:provider) }

        # ensure that on v3 and lower that the service registration resource is present
        context 'with repo_version="3"' do
          let(:pre_condition) { "class {'fluentd': repo_version => '3'}" }

          it do
            is_expected.to contain_fluentd_windows_service('fluentdwinsvc')
              .with(ensure: 'present',
                    command: 'C:/opt/td-agent/embedded/bin/fluentd.bat')
          end
        end
      else
        it { is_expected.to contain_service('td-agent').without(:provider) }
      end
    end
  end
end
