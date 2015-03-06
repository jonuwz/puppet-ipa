################################################################################
#
# puppet/provider/ipa_hostgroup/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_hostgroup).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:hostgroup

  def add_instance
    ipa.hostgroup.add(@resource[:name],{ :description => @resource[:description] })
  end

  def del_instance
    ipa.hostgroup.del(@resource[:name])
  end

  def mod_instance
    ipa.hostgroup.mod(@resource[:name],@property_flush)
  end

end
    
      

