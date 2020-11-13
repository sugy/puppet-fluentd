Puppet::Type.type(:package).provide :tdagent, parent: :gem, source: :gem do
  has_feature :install_options, :versionable

  # yes, i know this isn't how you're "supposed" to do it, but because
  # we're overriding the "gem" package provider here, we need this to be
  # one named provider for use in our package resources.
  if Puppet::Util::Platform.windows?
    if Puppet::FileSystem.exist?('C:/opt/td-agent/bin/fluent-gem.bat')
      # v4 and newer
      commands gemcmd: 'C:/opt/td-agent/bin/fluent-gem.bat'
    else
      # v3 and older
      commands gemcmd: 'C:/opt/td-agent/embedded/bin/fluent-gem.bat'
    end
  else
    if Puppet::FileSystem.exist?('/usr/sbin/td-agent-gem')
      # v3, v4 and newer
      commands gemcmd: '/usr/sbin/td-agent-gem'
    else
      # v0
      commands gemcmd: '/opt/td-agent/usr/sbin/td-agent-gem'
    end
  end
end
