################################################################################
#
# puppet/provider/ipa_group/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_group).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:group

  class << self
    alias_method :super_get_def, :get_def

    def get_def(instance)
      properties=super_get_def(instance)
      properties[:nonposix] = properties[:gid] ? :false : :true
      properties
    end

  end

  def add_instance
    options            = { :description => @resource[:description] }
    options[:nonposix] = true if @resource[:nonposix] == :true
    options[:gid]      = @resource[:gid] if @resource[:gid] and !options[:nonposix]
    ipa.group.add(@resource[:name],options)
  end
  
  def del_instance
    ipa.group.del(@resource[:name])
  end

  def mod_instance
    mods = {}
    @property_flush.each do |property,val|
      if property == :nonposix
        del_instance
        add_instance
      else
        mods[property] = @resource[property]
      end
    end
    ipa.group.mod(@resource[:name],mods) unless mods.empty?
  end
   
end
    
