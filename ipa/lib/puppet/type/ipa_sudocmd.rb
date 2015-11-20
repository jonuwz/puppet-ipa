################################################################################
#
# puppet/type/ipa_sudocmd.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_sudocmd) do
  @doc = <<-'EOS'
    Manages Sudo commands within IPA.

    Typically the properties are as they appear in the 'Sudo -> Sudo Commands' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

        ipa_sudocmd { '/etc/init.d/puppet':
          ensure => 'present',
        }
  EOS

  newparam(:name, :namevar => true) do
    desc '__String__ The name of the sudo command. This is the fully qualified path to the binary. Wildcards are allowed'
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
    desc '__String__ A description for the sudo command. Defaults to the name of the sudo command'
    defaultto { @resource[:name] }
  end

end

