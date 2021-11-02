require 'spec_helper'

RSpec.describe 'fluentd::config' do
  let(:pre_condition) { 'include fluentd' }

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
      # {
      #   'operatingsystem'        => 'Windows',
      #   'operatingsystemrelease' => ['2012', '2016', '2019'],
      # },
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'stdout.conf' }

      let(:params) do
        {
          config: {
            'system' => {
              'log_level' => 'warn',
            },
            'match' => {
              'tag_pattern' => '**',
              'type' => 'forward',
              'server' => [
                { 'host' => 'example1.com', 'port' => 24_224 },
                { 'host' => 'example2.com', 'port' => 24_224 },
              ],
            },
          },
        }
      end

      if os_facts[:os]['family'] == 'windows'
        it do
          is_expected.to contain_file('C:/opt/td-agent/etc/td-agent.d/stdout.conf')
            .with('ensure'  => 'file',
                  'owner'   => 'Administrator',
                  'group'   => 'Administrator',
                  'mode'    => nil,
                  'require' => 'Class[Fluentd::Install]',
                  'notify'  => 'Class[Fluentd::Service]')
            .with_content(%r{<system>})
            .with_content(%r{^[\s]+log_level warn})
            .with_content(%r{<match \*\*>})
            .with_content(%r{@type forward})
            .with_content(%r{<server>})
            .with_content(%r{host example1.com})
            .with_content(%r{port 24224})
            .with_content(%r{<\/server>})
            .with_content(%r{host example2.com})
            .with_content(%r{<\/match>})
        end
      else
        it do
          is_expected.to contain_file('/etc/td-agent/config.d/stdout.conf')
            .with('ensure'  => 'file',
                  'owner'   => 'td-agent',
                  'group'   => 'td-agent',
                  'mode'    => '0640',
                  'require' => 'Class[Fluentd::Install]',
                  'notify'  => 'Class[Fluentd::Service]')
            .with_content(%r{<system>})
            .with_content(%r{^[\s]+log_level warn})
            .with_content(%r{<match \*\*>})
            .with_content(%r{@type forward})
            .with_content(%r{<server>})
            .with_content(%r{host example1.com})
            .with_content(%r{port 24224})
            .with_content(%r{<\/server>})
            .with_content(%r{host example2.com})
            .with_content(%r{<\/match>})
        end
      end
    end
  end
end
