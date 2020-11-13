require 'puppet/resource_api'

# Manages the Windows Service registration for FluentD
Puppet::ResourceApi.register_type(
  name: 'fluentd_windows_service',
  desc: <<-EOS,
    Manages the Windows Service registration for FluentD
  EOS
  # specify this simple_get_filter so we don't have to query for _all_ instances
  # of the service recovery resources (slow)
  features: ['simple_get_filter', 'supports_noop'],
  attributes: {
    name: {
      type:      'String[1]',
      behaviour: :namevar,
      desc:      'Name of the service to register in Windows, this is the "short" name visible when looking at service properties or querying with sc.exe.',
    },
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this service key should be present or absent on the target system.',
    },
    command: {
      type: 'String',
      desc: 'FluentD command to use for registering the windows service for td-agent v3.',
      default: 'C:/opt/td-agent/embedded/bin/fluentd.bat',
      behavior: :parameter,
    },
    display_name: {
      type:    'String[1]',
      desc:    'Display name of the service in the services.msc view of windows.',
      default: 'Fluentd Windows Service',
    },
    description: {
      type:    'String[1]',
      desc:    'Description of the service visible in Windows',
      default: 'Fluentd is an event collector system.',
    },
    fluentdopt: {
      type: 'String',
      desc: 'Path to the fluentd bin directory where the `command` above lives',
      default: '-c C:/opt/td-agent/etc/td-agent/td-agent.conf -o C:/opt/td-agent/td-agent.log',
    },
  },
)
