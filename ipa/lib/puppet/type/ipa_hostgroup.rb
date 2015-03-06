################################################################################
#
# puppet/type/ipa_hostgroup.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_hostgroup) do
  @doc = <<-'EOS'
    Manages hostgroups within IPA.

    Typically the properties are as they appear in the 'Host Groups' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

        ipa_hostgroup { 'puppet_servers':
          ensure      => 'present',
          description => 'Puppet Servers',
        }
  EOS


  newparam(:name, :namevar => true) do
    desc '__String__  The name of hte hostgroup'
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
    desc '__String__ A description for the hostgroup. Defaults to the name of the hostgroup'
    defaultto { @resource[:name] }
  end

end

