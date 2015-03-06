################################################################################
#
# puppet/provider/ipa_sudocmd/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_sudocmd).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:sudocmd

  def add_instance
    ipa.sudocmd.add(@resource[:name],{ :description => @resource[:description] })
  end

  def del_instance
    ipa.sudocmd.del(@resource[:name])
  end

  def mod_instance
    ipa.sudocmd.mod(@resource[:name],@property_flush)
  end

end
    
      

