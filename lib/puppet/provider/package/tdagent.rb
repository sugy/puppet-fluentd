Puppet::Type.type(:package).provide :tdagent, parent: :gem, source: :gem do
  has_feature :install_options, :versionable

  if Puppet::Util::Platform.windows?
    commands gemcmd: 'C:/opt/td-agent/embedded/bin/fluent-gem.bat'
  else
    commands gemcmd: '/opt/td-agent/usr/sbin/td-agent-gem'
  end
end
