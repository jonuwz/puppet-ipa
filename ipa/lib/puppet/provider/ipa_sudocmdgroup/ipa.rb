################################################################################
#
# puppet/provider/ipa_sudocmdgroup/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_sudocmdgroup).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:sudocmdgroup

  def add_instance
    ipa.sudocmdgroup.add(@resource[:name],{ :description => @resource[:description] })
    ipa.sudocmdgroup.add_member(resource[:name],@resource[:members]) if @resource[:members]
  end

  def del_instance
    ipa.sudocmdgroup.del(@resource[:name])
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
        ipa.sudocmdgroup.add_member(resource[:name],add_members) if add_members
        ipa.sudocmdgroup.remove_member(resource[:name],del_members) if del_members

      else
        mods[property] = val
      end
    end
    ipa.sudocmdgroup.mod(@resource[:name],mods) unless mods.empty?
  end

end
    
      

