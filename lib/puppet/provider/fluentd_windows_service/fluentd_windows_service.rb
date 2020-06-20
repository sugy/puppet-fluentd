# class to create the FluentD service on Windows
class Puppet::Provider::FluentdWindowsService::FluentdWindowsService
  def initialize
    @service_doesnt_exit_error = 'The specified service does not exist as an installed service.'
    @regex_service_name = Regexp.new(%r{SERVICE_NAME:\s*(.*)\s*})
    @regex_display_name = Regexp.new(%r{\s*DISPLAY_NAME\s*:\s*(.*)\s*})
    @regex_description = Regexp.new(%r{DESCRIPTION:\s*(.*)\s*})
  end

  #######################
  # public methods inherited from Resource API
  def get(context, names = nil)
    return [] unless names
    # get the service instances for each name
    names.map { |service_name| service_instance(context, service_name) }
  end

  def set(context, changes, noop: false)
    changes.each do |name, change|
      # changes[:is] contains the "cached" state of the resource returned by get()
      # changes[:should] contains the desired state declared in the Puppet DSL
      is = change.key?(:is) ? change[:is] : service_instance(context, name)
      should = change[:should]

      # should can be 'nil' if it needs to be deleted
      # we don't support deleting/purging service control options, so skip this change
      if should && should[:ensure] == 'present'
        if attribute_changed(context, name, :ensure, is, should)
          create(context, name, should, noop)
        else
          update(context, name, is, should, noop)
        end
      else
        delete(context, name, is, should, noop)
      end
    end
  end

  #######################
  # private method
  def service_instance(_context, service)
    # query the config for the service
    instance = {
      name: service,
      ensure: 'absent',
    }
    begin
      # check if the service exists (ensure)
      # read the display name all from 'sc.exe qc <service>'
      qc = sc('qc', service)
      qc.lines.each do |line|
        if (match = line.match(@regex_service_name))
          instance[:ensure] = 'present' if match.captures[0] == service
        elsif (match = line.match(@regex_display_name))
          instance[:display_name] = match.captures[0]
        end
      end

      # read the description from 'sc.exe qdescription <service>'
      qdescription = sc('qdescription', service)
      qdescription.lines.each do |line|
        next unless (match = line.match(@regex_description))
        instance[:description] = match.captures[0]
      end
    rescue Puppet::ExecutionFailure => e
      # if we get the following error, that just happens when the service
      # doesn't exist and we try to query it, ignore the error and use
      # the absent flag set above
      raise e unless e.output.include?(@service_doesnt_exit_error)
    end

    # the fluentdopt options are stored in the registry
    Win32::Registry::HKEY_LOCAL_MACHINE.open("SYSTEM\\CurrentControlSet\\Services\\#{service}", Win32::Registry::KEY_ALL_ACCESS) do |reg|
      instance[:fluentdopt] = reg['fluentdopt']
    end

    instance
  end

  def create(context, name, should, noop)
    arguments += ['--reg-winsvc', 'i'] # 'i' stands for install
    arguments += ['--winsvc-name', should[:name]]
    if should[:display_name]
      arguments += ['--winsvc-display-name', should[:display_name]]
    end
    if should[:description]
      arguments += ['--winsvc-display-name', should[:description]]
    end
    if should[:fluentdopt]
      arguments += ['--reg-winsvc-fluentdopt', should[:fluentdopt]]
    end

    # only report changes if noop
    if noop
      context.info("fluentd_windows_service[#{name}] would have run: #{should[:command]} #{arguments.join(' ')}")
    else
      # create the service
      commad(should[:command], arguments)
    end
  end

  def update(context, name, is, should, noop)
    # FYI the 'name' can't change because that would make it a different
    # because of the way puppet works
    if attribute_changed(context, name, :display_name, is, should)
      if noop
        context.info("fluentd_windows_service[#{name}] would have run: sc.exec config #{name} 'DisplayName=#{should[:display_name]}'")
      else
        sc(['config', name, "DisplayName=#{should[:display_name]}"])
      end
    end
    if attribute_changed(context, name, :description, is, should)
      if noop
        context.info("fluentd_windows_service[#{name}] would have run: sc.exec description #{name} '#{should[:description]}'")
      else
        sc(['description', name, should[:description]])
      end
    end
    if attribute_changed(context, name, :fluentdopt, is, should) # rubocop:disable Style/GuardClause
      if noop
        context.info("fluentd_windows_service[#{name}] would have set registry key SYSTEM\\CurrentControlSet\\Services\\#{name} to: #{should[:fluentdopt]}")
      else
        Win32::Registry::HKEY_LOCAL_MACHINE.open("SYSTEM\\CurrentControlSet\\Services\\#{name}", Win32::Registry::KEY_ALL_ACCESS) do |reg|
          reg['fluentdopt', Win32::Registry::REG_SZ] = should[:fluentdopt]
        end
      end
    end
  end

  def delete(context, name, _is, _should, noop)
    # delete the service
    if noop
      context.info("fluentd_windows_service[#{name}] would have run: sc.exec delete #{name} ")
    else
      sc(['delete', name])
    end
  end

  def sc(*args)
    # use Puppet::Provider::Command here because we're running a "native" command
    # this is MUCH faster than launching powershell, even with pwshlib
    @sc ||= Puppet::Provider::Command.new('sc',
                                          'sc.exe',
                                          Puppet::Util,
                                          Puppet::Util::Execution,
                                          failonfail: true,
                                          combine: true,
                                          custom_environment: {})
    @sc.execute(*args)
  end

  def command(cmd, *args)
    @command ||= Puppet::Provider::Command.new('fluentd',
                                               cmd,
                                               Puppet::Util,
                                               Puppet::Util::Execution,
                                               failonfail: true,
                                               combine: true,
                                               custom_environment: {})
    @command.execute(*args)
  end

  def attribute_changed(context, name, prop, is, should)
    changed = should[prop] && (is[prop] != should[prop])
    context.attribute_changed(name, prop.to_s, is[prop], should[prop]) if changed
    changed
  end
end
