################################################################################
#
# puppet/type/ipa_sudocmdgroup.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_sudocmdgroup) do
  @doc = <<-'EOS'
    Manages Sudo command groups within IPA.

    Typically the properties are as they appear in the 'Sudo -> Sudo Command Groups' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

        ipa_sudocmdgroup { 'puppet commands':
          ensure      => 'present',
          description => 'Stuff for puppet',
          members     => ['/etc/init.d/puppet', '/usr/bin/pupet'],
        }
  EOS

  newparam(:name, :namevar => true)  do
    desc '__String__  The name of the sudo command group'
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
    desc '__String__ A description ffor the sudo command group. Defaults to the name of the sudo command group'
    defaultto { @resource[:name] }
  end

  newproperty(:members, :array_matching => :all) do
    desc '__Array of strings__ A list of sudo commands `ipa_sudocmd` that constitute the sudo command group'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
     value.inspect
    end
  end

  autorequire(:ipa_sudocmd) do
    value(:members) if @parameters.include?(members)
  end

end

