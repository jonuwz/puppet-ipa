################################################################################
#
# puppet/type/ipa_hbacsvcgroup.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_hbacsvcgroup) do
  @doc = <<-'EOS'
    Manages Host Based Access Control service groups within IPA.

    Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Service Groups' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

        ipa_hbacsvcgroup { 'remote unix access':
          ensure      => 'present',
          description => 'ssh / sudo / ftp',
          members     => ['sshd', 'sudo'],
        }
  EOS

  newparam(:name, :namevar => true)  do
    desc '__String__ The name of the service groups'
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
    desc '__String__ A description for the service group. Defaults to the name of the service group'
    defaultto { @resource[:name] }
  end

  newproperty(:members, :array_matching => :all) do
    desc '__Array of strings__ A list of services `ipa_hbacsvc` that constitute the service group'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  autorequire(:ipa_hbacsvc) do
    value(:members) if @parameters.include?(:members)
  end

end

