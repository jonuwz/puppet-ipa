################################################################################
#
# puppet/provider/ipa_host/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_host).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:host

  def add_instance
    ipa.host.add(@resource[:name],{:ip_address => @resource[:ip_address]})
    mods = {}
    ipa.host.lookup.each do |pup_prop,int_prop|
      if @resource[pup_prop]
        if pup_prop == :managedby
          ipa.host.remove_managedby(@resource[:name],@resource[:name])
          ipa.host.add_managedby(@resource[:name],@resource[:managedby])
        elsif pup_prop == :hostgroups
          Array(@resource[:hostgroups]).each do |group|
            ipa.hostgroup.add_member(group,@resource[:name])
          end
        else
          mods[pup_prop] = @resource[pup_prop]
        end
      end
    end
    ipa.host.mod(@resource[:name],mods) unless mods.empty?
  end

  def mod_instance
    mods = {}
    @property_flush.each do |property,val|
      if property == :managedby
        add_managedby = []
        del_managedby = []
        Array(val).each do |host|
          add_managedby << host unless @property_hash[:managedby].include?(host)
        end
        @property_hash[:managedby].each do |host|
          del_managedby << host unless val.include?(host)
        end
        ipa.host.add_managedby(resource[:name],add_managedby) if add_managedby
        ipa.host.remove_managedby(resource[:name],del_managedby) if del_managedby
      elsif property == :hostgroups
        Array(val).each do |group|
          ipa.hostgroup.add_member(group,resource[:name]) unless @property_hash[:hostgroups].include?(group)
        end
        @property_hash[:hostgroups].each do |group|
          ipa.hostgroup.remove_member(group,resource[:name]) unless val.include?(group)
        end
      else
        mods[property] = resource[property]
      end
    end
    ipa.host.mod(@resource[:name],mods) unless mods.empty?
  end

  def del_instance
    ipa.host.del(@resource[:name],{:updatedns => true})
  end

end
    
