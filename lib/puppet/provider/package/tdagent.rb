Puppet::Type.type(:package).provide :tdagent, parent: :gem, source: :gem do
  has_feature :install_options, :versionable

  if Puppet.features.microsoft_windows?
    commands gemcmd: 'C:/opt/td-agent/usr/sbin/td-agent-gem'
  else
    commands gemcmd: '/opt/td-agent/usr/sbin/td-agent-gem'
  end
end
