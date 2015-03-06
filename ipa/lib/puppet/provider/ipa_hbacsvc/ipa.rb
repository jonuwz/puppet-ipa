################################################################################
#
# puppet/provider/ipa_hbacsvc/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_hbacsvc).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:hbacsvc

  def add_instance
    ipa.hbacsvc.add(@resource[:name],{ :description => @resource[:description] })
  end

  def del_instance
    ipa.hbacsvc.del(@resource[:name])
  end

  def mod_instance
    ipa.hbacsvc.mod(@resource[:name],@property_flush)
  end

end
    
      

