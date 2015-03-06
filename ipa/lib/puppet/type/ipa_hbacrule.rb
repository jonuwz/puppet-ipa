################################################################################
#
# puppet/type/ipa_hbacrule.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_hbacrule) do
  @doc = <<-'EOS'
    Manages Host Based Access Control rules within IPA.

    Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Rules' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    Note :
      The parameters 'anyuser', 'anyhost', 'anyservice', if true, will set
      users and usergroups, hosts and hostgroups, services and servicegroups
      to an empty value respectively.

      This allows you to keep values in your manifest and override them
   
          ipa_hbacrule { 'puppet admins - client':
            ensure        => 'present',
            anyhost       => 'true',
            anyservice    => 'false',
            anyuser       => 'false',
            servicegroups => ['remote unix access'],
            usergroups    => ['puppet_admins'],
          } 
  EOS

  newparam(:name, :namevar => true) do
    desc "__String__ The name of the hbac rule"
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

  newproperty(:description) do
    desc '__String__ A description for the hbac rule. Defaults to the name of the hbac rule'
    defaultto { @resource[:name] }
  end

  newproperty(:hosts, :array_matching => :all) do
    desc '__Array of strings__ a list of hosts `ipa_host` that this hbac rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:hostgroups, :array_matching => :all) do
    desc '__Array of strings__ A list of hostgroups `ipa_hostgroup` that this hbac rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:services, :array_matching => :all) do
    desc '__Array of strings__ A list of services `ipa_hbacsvc` that this hbac rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:servicegroups, :array_matching => :all) do
    desc '__Array of strings__ A list of servicegroups `ipa_hbacsvcgroup` that this hbac rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:users, :array_matching => :all) do
    desc '__Array of strings__ a list of users `ipa_user` that this hbac rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:usergroups, :array_matching => :all) do
    desc '__Array of strings__ a list of usergroups `ipa_groups` that this hbac rule applies to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:anyhost, :boolean => true) do
    desc '__Boolean__ Whether this hbac rule applies to all hosts. Overrides hosts/hostgroups'
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
    desc '__Boolean__ Whether this hbac rule applies to all users. Overrides users/usergroups'
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

  newproperty(:anyservice, :boolean => true) do
    desc '__Boolean__ Whether this hbac rule applies to all services. Overrides services/servicegroups'
    newvalues(:true,:false)
    defaultto(:false)

    munge do |value|
      case value
      when :true, 'true', true
        @resource[:services]=[]
        @resource[:servicegroups]=[]
        :true
      when :false, 'false', false
        :false
      end
    end

  end

  autorequire(:ipa_hbacsvc) do
    value(:services) if @parameters.include?(:services)
  end

  autorequire(:ipa_hbacsvcgroup) do
    value(:servicegroups) if @parameters.include?(:servicegroups)
  end

  autorequire(:ipa_user) do
    value(:users) if @parameters.include?(:users)
  end
  autorequire(:ipa_group) do
    value(:usergroups) if @parameters.include?(:usergroups)
  end
  autorequire(:ipa_host) do
    value(:hosts) if @parameters.include?(:hosts)
  end
  autorequire(:ipa_hbacsvc) do
    value(:hostgroups) if @parameters.include?(:hostgroups)
  end

end

