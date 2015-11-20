################################################################################
#
# puppet/type/ipa_user.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
Puppet::Type.newtype(:ipa_user) do

  @doc = <<-EOS
    Manages user accounts within IPA.

    Typically the properties are as they appear in the 'Users' section of the web interface,
    lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    The password parameter is only used on create and is not ensurable.

        ipa_user { 'john':
          ensure            => 'present',
          first_name        => 'John',
          last_name         => 'Wibble',
          full_name         => "$first_name $last_name"
          uid               => '800200001',
          gecos             => "usr_$name_$uid",
          home_directory    => "/home/$name",
          login_shell       => '/bin/bash',
          ssh_public_keys   => 'ssh-rsa AAAAB3NzaC1yc2EA ... e5JmsDLkkA5e+XOzWzi01IVTkYXNdpTv john@auto.local',
          telephone_numbers => ['12345678'],
          usergroups        => ['admins', 'puppet_admins'],
        }
  EOS
    
  newparam(:user, :namevar => true) do
    desc '__String__ The username, i.e. jhughesj'
  end

  newparam :password do
    desc '__String__ The initial password for hte account'
  end

  ensurable do
    desc 'Whether the resource should exist or not'
    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  newproperty(:title) do
    desc '__String__ Users title, i.e. Mr, Ms'
  end

  newproperty(:first_name) do
    desc '__String__'
  end

  newproperty(:last_name) do
    desc '__String__'
  end

  newproperty(:full_name) do
    desc '__String__'
  end

  newproperty(:display_name) do
    desc '__String__'
  end

  newproperty(:initials) do
    desc '__String__'
  end

  newproperty(:gecos) do
    desc '__String__ The string that will appear in the comment field on unix systems for the user'
  end

  newproperty(:uid) do
    desc '__Integer__ The user ID. If unset, will be automatically generated'
  end

  newproperty(:gid) do
    desc '__Integer__ The user ID. If unset, will be inherited from the default group'
  end

  newproperty(:login_shell) do
    desc '__String__ The users default login shell. i.e. /bin/bash'
  end

  newproperty(:home_directory) do
    desc '__String__ The users default login shell. i.e. /bin/bash. Defaults to /home/<user>'
  end

  newproperty(:mail) do
    desc '__String__ The users email address. Defaults to <user>@domain'
  end

  newproperty(:telephone_numbers, :array_matching => :all) do
    desc '__Array of strings__ Telephone numbers for the user. Single values are converted to arrays'
   def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
   def should_to_s(value)
     value.inspect
   end
  end

  newproperty(:pager_numbers, :array_matching => :all) do
    desc '__Array of strings__ Pager numbers for the user. Single values are converted to arrays'
   def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
   def should_to_s(value)
     value.inspect
   end
  end

  newproperty(:mobile_numbers, :array_matching => :all) do
    desc '__Array of strings__ Mobile numbers for the user. Single values are converted to arrays'
   def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
   def should_to_s(value)
     value.inspect
   end
  end

  newproperty(:fax_numbers, :array_matching => :all) do
    desc '__Array of strings__ Fax numbers for the user. Single values are converted to arrays'
   def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
   def should_to_s(value)
     value.inspect
   end
  end

  newproperty(:street_address) do
    desc '__String__ The users street address. i.e. 57 Mount Pleasant Street'
  end

  newproperty(:city) do
    desc '__String__ The users city of residence'
  end

  newproperty(:state) do
    desc '__String__  The users state of residence' 
  end

  newproperty(:zip) do
    desc '__String__ The users zip code / post code'
  end

  newproperty(:org_unit) do
    desc '__String__ The users organizational unit. Typically the department'
  end

  newproperty(:manager) do
    desc '__String__ The users manager. This is an existing user'
  end

  newproperty(:car_license) do
    desc '__String__ The users car license plate number'
  end

  newproperty(:ssh_public_keys, :array_matching => :all) do
    desc '__Array of strings__ An array of ssh public keys for the user. This allows login without passwords providing the private key is present'
   def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
   def should_to_s(value)
     value.inspect
   end
  end

  newproperty(:usergroups, :array_matching => :all) do
    desc '__Array of strings__ An array of groups that the user belongs to'
   def insync?(is)
      Array(is).sort.eql?(Array(should).sort)
    end
   def should_to_s(value)
     value.inspect
   end
  end

  autorequire(:ipa_group) do
    value(:usergroups) if @parameters.include?(:usergroups)
  end

  autorequire(:ipa_user) do
    value(:manager) if @parameters.include?(:manager)
  end

end

