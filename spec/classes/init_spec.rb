require 'spec_helper'

RSpec.describe 'fluentd' do
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
          allow_any_instance_of(Win32::Registry).to receive(:[])
            .with('ChocolateyInstall')
            .and_return('C:/ProgramData/chocolatey')
        end
      else
        let(:facts) { os_facts }
      end

      context 'base' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('fluentd') }
        it { is_expected.to contain_class('fluentd::install') }
        it { is_expected.to contain_class('fluentd::service') }
      end

      context 'with plugins' do
        let(:params) { { plugins: { plugin_name => plugin_params } } }
        let(:plugin_name) { 'fluent-plugin-http' }
        let(:plugin_params) { { 'plugin_ensure' => '0.1.0' } }

        it { is_expected.to contain_fluentd__plugin(plugin_name).with(plugin_params) }
      end

      context 'with configs' do
        let(:params) { { configs: { config_name => config_params } } }
        let(:config_name) { '100_fwd.conf' }
        let(:config_params) { { 'config' => { 'source' => { 'type' => 'forward' } } } }

        it { is_expected.to contain_fluentd__config(config_name).with(config_params) }
      end
    end
  end
end
