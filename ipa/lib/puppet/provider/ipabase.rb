################################################################################
#
# puppet/provider/ipabase.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
require 'puppet/provider'
require 'puppet/util/ipajson'

class Puppet::Provider::IPAbase < Puppet::Provider

  @@ipa=IPA.new('ipa.auto.local')
  
  def self.ipa
    @@ipa
  end

  def ipa
    self.class.ipa
  end

  def self.mk_resource_methods
    [resource_type.validproperties, resource_type.parameters].flatten.each do |attr|
      attr = attr.intern
      next if attr == :name
      define_method(attr) do
        if @property_hash[attr].nil?
          :absent
        else
          @property_hash[attr]
        end
      end

      define_method(attr.to_s + "=") do |val|
        @property_flush[attr] = val
      end
    end
  end

  def self.ipa_resource
    @ipa_resource
  end

  # TODO : I can collect all the instance details with 1 call.
  # replace show(instance) with batch to return all instance defs
  # in a hash

  def self.ipa_instances
    ipa.send(@ipa_resource).find_all
  end

  def self.instances
    ipa_instances.collect do |name|
       new(get_def(name))
    end
  end

  def self.get_def(instance)
    properties={:name => instance, :provider => :ipa}
    properties[:ensure] = ipa_instances.include?(instance) ? :present : :absent

    if properties[:ensure] == :present
      is = ipa.send(@ipa_resource).show(instance)
      ipa.send(@ipa_resource).lookup.each do |pup_prop,int_prop|
        properties[pup_prop] = Array(is[int_prop.to_s])
        properties[pup_prop] = properties[pup_prop].first unless ipa.send(@ipa_resource).prop_array?(pup_prop)
      end
    end
    properties
  end


  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def initialize(value={})
    @property_flush={}
    super(value)
  end

  def create
    @property_flush[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def flush
    if @property_flush[:ensure] == :present
      add_instance
      return
    end
    if @property_flush[:ensure] == :absent
      del_instance
      return
    end
    mod_instance
  end

end
