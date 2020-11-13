Puppet::Type.type(:package).provide :tdagent, parent: :gem, source: :gem do
  has_feature :install_options, :versionable
  confine operatingsystem: :windows
  commands gemcmd: 'C:/opt/td-agent/bin/fluent-gem.bat'
end
