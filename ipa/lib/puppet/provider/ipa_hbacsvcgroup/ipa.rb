################################################################################
#
# puppet/provider/ipa_hbacsvcgroup/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_hbacsvcgroup).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:hbacsvcgroup

  def add_instance
    ipa.hbacsvcgroup.add(@resource[:name],{ :description => @resource[:description] })
    ipa.hbacsvcgroup.add_member(resource[:name],@resource[:members]) if @resource[:members]
  end

  def del_instance
    ipa.hbacsvcgroup.del(@resource[:name])
  end

  def mod_instance
    mods = {}
    @property_flush.each do |property,val|
      if property == :members

        add_members = []
        del_members = []
        Array(val).each do |member|
          add_members << member unless @property_hash[:members].include?(member)
        end
        @property_hash[:members].each do |member|
          del_members << member unless val.include?(member)
        end
        ipa.hbacsvcgroup.add_member(resource[:name],add_members) if add_members
        ipa.hbacsvcgroup.remove_member(resource[:name],del_members) if del_members

      else
        mods[property] = val
      end
    end
    ipa.hbacsvcgroup.mod(@resource[:name],mods) unless mods.empty?
  end

end
    
      

