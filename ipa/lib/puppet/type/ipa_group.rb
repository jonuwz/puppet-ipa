################################################################################
#
# puppet/type/ipa_group.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_group) do
  @doc = <<-'EOS'
    Manages user groups within IPA.

    Typically the properties are as they appear in the 'User Groups' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    The nonposix parameter, if changed, will destroy and re-create the group.

        ipa_group { 'editors':
          ensure      => 'present',
          description => 'Limited admins who can edit other users',
          gid         => '800200002',
          nonposix    => 'false',
        }
  
  EOS

  newparam(:name, :namevar => true) do
    desc "__String__ The name of the group"
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

  newproperty(:gid) do
    desc '__Integer__ The gid of the group. Will be auto generated if absent'
  end

  newproperty(:description) do
    desc '__String__ A description for the group. Defaults to the name'
    defaultto { @resource[:name] }
  end

  newproperty(:nonposix, :boolean => true) do
    desc '__Boolean__ Whether this is a unix group or not. A true value will not create a GID for the group'
    newvalues(:true,:false)
  end

end

