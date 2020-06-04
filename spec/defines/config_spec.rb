require 'spec_helper'

RSpec.describe 'fluentd::config' do
  let(:pre_condition) { 'include fluentd' }

  context 'with redhat', :redhat do
    let(:title) { 'stdout.conf' }

    context 'when config contains nested hashes' do
      let(:params) do
        {
          config: {
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

      it do
        is_expected.to contain_file('/etc/td-agent/config.d/stdout.conf')
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
