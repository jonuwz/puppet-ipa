################################################################################
#
# puppet/type/ipa_host.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_host) do
  @doc = <<-'EOS'
    Manages host details within IPA.

    This type is most useful when collected on the IPA server from exported resources.

    Typically the properties are as they appear in the 'Hosts' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    The ip_address parameter is used only on creation to populate DNS

        ipa_host { 'ipa.auto.local':
          ensure           => 'present',
          description      => 'Primary IPA server',
          locality         => 'Timbuktu',
          location         => 'datahall 1 rack 2',
          managedby        => "ipa.$::domain",
          operating_system => "$::operatingsystem $::operatingsystemrelease",
          platform         => $::architecture,
        }
  EOS

  newparam(:name, :namevar => true) do
    desc "__String__ The fully qualified hostname"
    isnamevar
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

  newparam(:ip_address) do
    desc '__String__ The IP address of the server. A sane default is `$::ipaddress`'
  end

  newproperty(:description) do
    desc '__String__ A description for the server. Defaults to the name of the host'
    defaultto { @resource[:name] }
  end

  newproperty(:locality) do
    desc '__String__ Locality of the server'
  end

  newproperty(:location) do
    desc '__String__ Location of the server'
  end
  
  newproperty(:platform) do
    desc '__String__  Platform of the server. A sane value is `$::architecture`'
  end

  newproperty(:operating_system) do
    desc '__String__  OS of the server. A sane value is `"$::operatingsystem $::operatingsystemrelease"`'
  end

  newproperty(:managedby, :array_matching => :all) do
    desc '__Array of strings__ A list of ipa servers managing this server. Typically this is your IPA server'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  newproperty(:hostgroups, :array_matching => :all) do
    desc '__Array of strings__ A list of hostgroups this server belongs to'
    def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
    def should_to_s(value)
      value.inspect
    end
  end

  autorequire(:ipa_hostgroup) do
    value(:hostgroups) if @parameters.include?(:hostgroups)
  end

  autorequire(:ipa_host) do
    value(:managedby) if @parameters.include?(:managedby)
  end

end

