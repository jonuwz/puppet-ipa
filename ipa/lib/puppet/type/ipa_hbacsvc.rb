################################################################################
#
# puppet/type/ipa_hbacsvc.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_hbacsvc) do

  @doc = <<-'EOS'
    Manages Host Based Access Control servcies within IPA.

    Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Services' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

        ipa_hbacsvc { 'sudo':
          ensure      => 'present',
          description => 'sudo',
        }
  EOS

  newparam(:name, :namevar => true) do
    desc '__String__  The name of the service'
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
    desc '__String__ A description for the service. Defaults to the name of the service'
    defaultto { @resource[:name] }
  end

end

