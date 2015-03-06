################################################################################
#
# puppet/provider/ipa_user/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_user).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:user

  mk_resource_methods

  def add_instance
    options = { :password   => @resource[:password],
                :first_name => @resource[:first_name],
                :last_name  => @resource[:last_name], }
    ipa.user.add(@resource[:name],options)
    mods = {}
    ipa.user.lookup.each do |pup_prop,int_prop|
      if @resource[pup_prop]
        if pup_prop == :usergroups
          Array(@resource[:groups]).each do |group|
            ipa.group.add_member(group,@resource[:name])
          end
         else
          mods[pup_prop] = @resource[pup_prop]
        end
      end
    end
    ipa.user.mod(@resource[:name],mods) unless mods.empty?
  end

  def mod_instance
    mods = {}
    @property_flush.each do |property,val|
      if property == :usergroups
       Array(val).each do |group|
          ipa.group.add_member(group,resource[:name]) unless @property_hash[:usergroups].include?(group)
        end
        @property_hash[:usergroups].each do |group|
          ipa.group.remove_member(group,resource[:name]) unless val.include?(group)
        end
      else
        puts property;p val
        mods[property] = val
      end
    end
    p mods
    ipa.user.mod(@resource[:name],mods) unless mods.empty?
  end

  def del_instance
    ipa.user.del(@resource[:name])
  end

end
    
