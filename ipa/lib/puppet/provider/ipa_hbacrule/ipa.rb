################################################################################
#
# puppet/provider/ipa_hbacrule/ipa.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/util/ipajson'
require 'puppet/provider/ipabase'

Puppet::Type.type(:ipa_hbacrule).provide(:ipa, :parent => Puppet::Provider::IPAbase) do

  mk_resource_methods
  @ipa_resource=:hbacrule

  class << self
    alias_method :super_get_def, :get_def

    def get_def(instance)
      properties=super_get_def(instance)
      [:anyuser,:anyhost,:anyservice].each do |cat|
        properties[cat] ||= :false
        properties[cat]   = :true if properties[cat] =='all'
      end
      properties
    end

  end

  def add_instance
    ipa.hbacrule.add(@resource[:name],{ :description => @resource[:description] })
    [:user,:host,:service].each do |type|
   
      single = "#{type}s".to_sym
      group  = "#{type}groups".to_sym
      cat    = "any#{type}".to_sym

      modify_members(single,@resource[single],[]) if @resource[single]
      modify_members(group, @resource[group],[])  if @resource[group]
      ipa.hbacrule.mod(@resource[:name],{ cat => 'all' }) if @resource[cat]==:true

    end

  end

  def del_instance
    ipa.hbacrule.del(@resource[:name])
  end

  def modify_members(property,members,current_members)

     method="#{property}".sub(/s$/,'')
     add_members = []
     del_members = []

     Array(members).each do |member|
        add_members << member unless current_members.include?(member)
      end
      current_members.each do |member|
        del_members << member unless members.include?(member)
      end

      ipa.hbacrule.send("add_#{method}".to_sym, @resource[:name],add_members) if !add_members.empty?
      ipa.hbacrule.send("remove_#{method}".to_sym, @resource[:name],del_members) if !del_members.empty?
      @property_flush.delete(property)

  end
 
  
  def mod_instance

    # arses.
    # when user/service/hostcategory = all, then you have to delete all the relevant user/service/group definitions in IPA
    # sanest thing to do is overwrite the should values for the user/host/group contents with []
    # then the user can just remove the user/host/servicecategory = all from he manifest and get hte old settings back

    [:user,:host,:service].each do |type|
    
      single = "#{type}s".to_sym
      group  = "#{type}groups".to_sym
      cat    = "any#{type}".to_sym

      # future state is all = true. We need to wipe the single/group properties before applying the 'all setting'
      # the type itself looks after overriding the single/group
      if ( !@property_flush.has_key?(cat) and @property_hash[cat] == :true) or @property_flush[cat]==:true

        modify_members(single,@property_flush[single],@property_hash[single]) if @property_flush.has_key?(single)
        modify_members(group, @property_flush[group],@property_hash[group])  if @property_flush.has_key?(group)
        ipa.hbacrule.mod(@resource[:name],{ cat => 'all' }) if @property_flush[cat]==:true
        

      # future state is all = false and requires a change to 'all' setting before applying single/group membership
      elsif @property_flush.has_key?(cat) and @property_hash[cat] == :true

        ipa.hbacrule.mod(@resource[:name],{ cat => '' }) if @property_flush[cat]==:false
        modify_members(single,@property_flush[single],@property_hash[single]) if @property_flush.has_key?(single)
        modify_members(group ,@property_flush[group],@property_hash[group])  if @property_flush.has_key?(group)

      # just flush the single/group members
      else
  
        modify_members(single,@property_flush[single],@property_hash[single]) if @property_flush.has_key?(single)
        modify_members(group ,@property_flush[group],@property_hash[group])  if @property_flush.has_key?(group)

      end

    end

    ipa.hbacrule.mod(@resource[:name],{ :description => @property_flush[:description]}) if @property_flush.has_key?(:description)

  end
  
end
