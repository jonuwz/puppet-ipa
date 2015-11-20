################################################################################
#
# puppet/type/ipa_sudorule.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_sudorule) do

  @doc = <<-'EOS'
    Manages Sudo rules within IPA.

    Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Rules' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    Note :
      The parameters 'anyuser', 'anyhost', 'anycommand', if true, will set
      users and usergroups, hosts and hostgroups, allow/deny_commands and allow/deny_commandgroups
      to an empty value respectively.

      The parameters 'anyrunasuser' and 'anyrunasgroup', if true, will set
      runasusers / runasusergroups / runasgroups to an empty value 

      This allows you to keep values in your manifest and override them

        ipa_sudorule { 'puppet administration - client':
          ensure              => 'present',
          allow_commandgroups => ['puppet commands'],
          anycommand          => 'false',
          anyhost             => 'true',
          anyrunasgroup       => 'false',
          anyrunasuser        => 'false',
          anyuser             => 'false',
          options             => ['!authenicate'],
          usergroups          => ['puppet_admins'],
        }
  EOS


  newparam(:name, :namevar => true) do
    desc '__String__ The name of the sudo rule'
  end

  ensurable do
    desc 'Whether the resource should exist or not'
    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

  end

  newproperty(:options, :array_matching => :all) do
    desc '__Array of strings__ A list of options that the sudo rule. i.e. `["!authenticatei"]`'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:description) do
    desc '__String__ A description for the sudo rule. Defaults to hte name of the sudo rule'
    defaultto { @resource[:name] }

  end

  newproperty(:hosts, :array_matching => :all) do
    desc '__Array of strings__ A list of hosts `ipa_host` that the sudo rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:hostgroups, :array_matching => :all) do
    desc '__Array of strings__ A list of hostgroups `ipa_hostgroup` that the sudo rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:runasusers, :array_matching => :all) do
    desc '__Array of strings__ A list of users `ipa_user` that the sudo commands in the rule can be run as'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:runasusergroups, :array_matching => :all) do
    desc '__Array of strings__ A list of usergroups `ipa_groups` that contain users that the sudo commands in the rule can be run as'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:runasgroups, :array_matching => :all) do
    desc '__Array of strings__  A list of usergroups `ipa_group` that the sudo commands in the rule can be run as'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:allow_commands, :array_matching => :all) do
    desc '__Array of strings__  A list of commands `ipa_sudocmd` that the sudo rule allows to be run'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:allow_commandgroups, :array_matching => :all) do
    desc '__Array of strings__ A list of commandgroups `ipa_sudocmdgroup` that the sudo rule allows to be run'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:deny_commands, :array_matching => :all) do
    desc '__Array of strings__ A list of commands `ipa_sudocmd` that the sudo rule prevents from running'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:deny_commandgroups, :array_matching => :all) do
    desc '__Array of strings__  A list of commandgroups `ipa_sudocmdgroup` that the sudo rule prevents from running'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end


  newproperty(:users, :array_matching => :all) do
    desc '__Array of strings__ A list of users `ipa_user` permitted to run the commands in the sudo rule'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:usergroups, :array_matching => :all) do
    desc '__Array of strings__ A list of usergroups `ipa_group` whose users are permitted to run the commands in the sudo rule'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:anyhost, :boolean => true) do
    desc '__Boolean__ Whether this sudo rule applies to all hosts. Overrides hosts/hostgroups'
    newvalues(:true,:false)
    defaultto(:false)

    munge do |value|
      case value
      when :true, 'true', true
        @resource[:hosts]=[]
        @resource[:hostgroups]=[]
        :true
      when :false, 'false', false
        :false
      end
    end

  end

  newproperty(:anyuser, :boolean => true) do
    desc '__Boolean__ Whether this sudo rule applies to all users. Overrides users/usergroups'
    newvalues(:true,:false)
    defaultto(:false)

    munge do |value|
      case value
      when :true, 'true', true
        @resource[:users]=[]
        @resource[:usergroups]=[]
        :true
      when :false, 'false', false
        :false
      end
    end

  end

  newproperty(:anycommand, :boolean => true) do
    desc '__Boolean__ Whether this sudo rule applies to all commands. Overrides allow/deny_command(group)s'
    newvalues(:true,:false)
    defaultto(:false)

    munge do |value|
      case value
      when :true, 'true', true
        @resource[:allow_commands]=[]
        @resource[:allow_commandgroups]=[]
        @resource[:deny_commands]=[]
        @resource[:deny_commandgroups]=[]
        :true
      when :false, 'false', false
        :false
      end
    end

  end

  newproperty(:anyrunasuser, :boolean => true) do
    desc '__Boolean__ Whether this sudo rule can run as any user. Overrides runasuser/runasusergroups/runasgroup'
    newvalues(:true,:false)
    defaultto(:false)

    munge do |value|
      case value
      when :true, 'true', true
        @resource[:runasusers]=[]
        @resource[:runasusergroups]=[]
        @resource[:runasgroups]=[]
        :true
      when :false, 'false', false
        :false
      end
    end

  end

  newproperty(:anyrunasgroup, :boolean => true) do
    desc '__Boolean__ Whether this sudo rule can run as any group. Overrides runasuser/runasusergroups/runasgroup'
    newvalues(:true,:false)
    defaultto(:false)

    munge do |value|
      case value
      when :true, 'true', true
        @resource[:runasusers]=[]
        @resource[:runasusergroups]=[]
        @resource[:runasgroups]=[]
        :true
      when :false, 'false', false
        :false
      end
    end

  end

  autorequire(:ipa_user) do
    users=[]
    users << value(:users) if @parameters.include?(:users)
    users << value(:runasusers) if @parameters.include?(:runasusers)
    users.uniq
  end

  autorequire(:ipa_group) do
    groups=[]
    groups << value(:usergroups) if @parameters.include?(:usergroups)
    groups << value(:runasusergroups) if @parameters.include?(:runasusergroups)
    groups.uniq
  end

  autorequire(:ipa_hosts) do
    value(:hosts) if @parameters.include?(:hosts)
  end

  autorequire(:ipa_hostgroups) do
    value(:hostgroups) if @parameters.include?(:hostgroups)
  end

  autorequire(:ipa_sudocmd) do
    value(:allow_commands) if @parameters.include?(:allow_commands)
  end

  autorequire(:ipa_sudocmdgroup) do
    value(:allow_commandgroups) if @parameters.include?(:allow_commandgroups)
  end

end

