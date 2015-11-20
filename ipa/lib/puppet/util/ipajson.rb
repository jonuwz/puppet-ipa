################################################################################
#
# puppet/util/ipajson.rb
#
# Copyright 2013-2015 jonuwz (https://github.com/jonuwz)
#
# See LICENSE.md for Licensing.
#
################################################################################
module IPAcommon

  @@IPAfind_element = {
    :hostgroup    => 'cn',
    :group        => 'cn',
    :sudocmd      => 'sudocmd',
    :sudorule     => 'cn',
    :sudocmdgroup => 'cn',
    :hbacrule     => 'cn',
    :hbacsvc      => 'cn',
    :hbacsvcgroup => 'cn',
    :host         => 'fqdn',
    :user         => 'uid',
  }

  def initialize(parent)
    @parent   = parent
    @ipaclass = self.class.name.downcase.sub(/^ipa/,'')
  end

  def post(*args)
    @parent.post(*args)
  end

  def find_element
    @@IPAfind_element[@ipaclass.to_sym]
  end

  def find_all
    results = []
    res = post("#{@ipaclass}_find", [[nil],{"pkey_only" => true,"sizelimit" => 0}] )
    res['result']['result'].each do |group|
      results << group[self.find_element].first
    end
    results
  end

  def show(target)
    res = post("#{@ipaclass}_show", [[target],{"all" => true, "rights" => true}] )
    res['result']['result']
  end

  def add(target,opthash={})
    options={}
    opthash.each do |key,val|
      newkey = lookup.has_key?(key) ? lookup[key] : key
      options[newkey.to_s] = val
    end
    post("#{@ipaclass}_add", [[target],options] )
  end

  def mod(target,opthash={})
    options={:all => true, :rights => true}
    opthash.each do |key,val|
      newkey = lookup.has_key?(key) ? lookup[key] : key
      options[newkey.to_s] = val
    end
    post("#{@ipaclass}_mod", [[target],options] )
  end

  def del(target,opthash={})
    options={}
    opthash.each do |key,val|
      newkey = lookup.has_key?(key) ? lookup[key] : key
      options[newkey.to_s] = val
    end
    post("#{@ipaclass}_del", [[target],{}] )
  end

end  

module IPAmembers

  @@IPAmember_element = {
    :hostgroup    => :host,
    :group        => :user,
    :sudocmdgroup => :sudocmd,
    :hbacsvcgroup => :hbacsvc,
  }
  
  def member_element
    @@IPAmember_element[@ipaclass.to_sym]
  end

  [:add, :remove ].each do |action|
    meth = "#{action}_member"
    define_method(meth) do |target,members|
      members = Array(members)
      post("#{@ipaclass}_#{meth}", [[target],{"all" => true, self.member_element => members}] )
    end
  end

  def find(target)
    res = show(target)
    res["member_#{self.member_element}"]
  end

end

class IPAhost
  include IPAcommon

  @@lookup=
    { :description => :description,
      :locality => :l,
      :location => :nshostlocation,
      :platform => :nshardwareplatform,
      :operating_system => :nsosversion,
      :managedby => :managedby_host,
      :hostgroups => :memberof_hostgroup,
    }
 
  @@arrays=[:managedby, :hostgroups, :managedby_host, :memberof_hostgroup]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

  [:remove,:add].each do |meth|
    define_method("#{meth}_managedby") do |target,members|
      members = Array(members)
      post("#{@ipaclass}_#{meth}_managedby", [[target], { :all => true, :host => members }] )
    end
  end
end

class IPAuser

  include IPAcommon
  @@lookup=
    { :title => :title,
      :first_name => :givenname,
      :last_name => :sn,
      :full_name => :cn,
      :display_name => :display_name,
      :initials => :initials,
      :gecos => :gecos,
      :uid => :uidnumber,
      :gid => :gidnumber,
      :login_shell => :loginshell,
      :home_directory => :homedirectory,
      :mail => :mail,
      :telephone_numbers => :telephonenumber,
      :pager_numbers => :pager,
      :mobile_numbers => :mobile, 
      :fax_numbers => :facsimiletelephonenumber,
      :street_address => :street,
      :city => :l,
      :state => :st,
      :zip => :postalcode,
      :org_unit => :ou,
      :manager => :manager,
      :usergroups => :memberof_group,
      :car_license => :carlicense,
      :password => :userpassword,
      :ssh_public_keys => :ipasshpubkey,
    }

  @@arrays=
    [:ssh_public_keys, :fax_numbers, :mobile_numbers, :pager_numbers,
     :telephone_numbers, :usergroups, ]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end
  
class IPAhostgroup 

  include IPAcommon
  include IPAmembers

  @@lookup=
    { :description => :description }

  @@arrays=[]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end

class IPAgroup
  include IPAcommon
  include IPAmembers

  @@lookup=
    { :gid         => :gidnumber,
      :description => :description,
      :nonposix    => :nonposix }

  @@arrays=[]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end

class IPAsudorule
  include IPAcommon

  [:user, :host, :allow_command, :deny_command, :runasuser, :runasgroup ].each do |cat|
    [:add, :remove ].each do |action|
      meth       = "#{action}_#{cat}"
      group_meth = "#{meth}group".to_sym
      types = { :user          => [:user,:group],
                :host          => [:host,:hostgroup],
                :allow_command => [:sudocmd,:sudocmdgroup],
                :deny_command  => [:sudocmd,:sudocmdgroup],
                :runasuser     => [:user,:group],
                :runasgroup    => [:group],
              }

      define_method(meth) do |target,members|
        members = Array(members)
        post("#{@ipaclass}_#{meth}", [[target],{types[cat][0] => members}] )
      end
      if types[cat].size > 1
        define_method(group_meth) do |target,members|
          members = Array(members)
          post("#{@ipaclass}_#{meth}", [[target],{types[cat][1] => members}] )
        end
      end
    end
  end
  
  def mod(target,opthash={})
    options={:all => true, :rights => true}
    opthash.each do |key,val|
      newkey = lookup.has_key?(key) ? lookup[key] : key
      options[newkey] = val
    end
    post("#{@ipaclass}_mod", [[target],options] )
  end
  
  @@lookup={
    :options                => :ipasudoopt,
    :users                  => :memberuser_user,
    :usergroups             => :memberuser_group,
    :hosts                  => :memberhost_host,
    :hostgroups             => :memberhost_hostgroup,
    :runasusers             => :ipasudorunas_user,
    :runasusergroups        => :ipasudorunas_group,
    :runasgroups            => :ipasudorunasgroup_group,
    :allow_commands         => :memberallowcmd_sudocmd,
    :allow_commandgroups    => :memberallowcmd_sudocmdgroup,
    :deny_commands          => :memberdenycmd_sudocmd,
    :deny_commandgroups     => :memberdenycmd_sudocmdgroup,
    :description            => :description,
    :anyuser                => :usercategory,
    :anyhost                => :hostcategory,
    :anycommand             => :cmdcategory,
    :anyrunasuser           => :ipasudorunasusercategory,
    :anyrunasgroup          => :ipasudorunasgroupcategory,  
  }

  @@arrays=[:users, :usergroups, :hosts, :hostgroups, :allow_commands, :allow_commandgroups,
            :deny_commands, :deny_commandgroups, :runasusers, :runasusergroups, :runasgroups,
            :options, ]
      
  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end  
  
end

class IPAsudocmd
  include IPAcommon

  @@lookup=
    { :description => :description, }

  @@arrays=[]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end

class IPAsudocmdgroup
  include IPAcommon
  include IPAmembers

  @@lookup=
    { :description => :description,
      :members     => :member_sudocmd,
    }

  @@arrays=[:members, :member_sudocmd]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end

class IPAhbacsvc
  include IPAcommon

  @@lookup=
    { :description => :description, }

  @@arrays=[]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end

class IPAhbacrule
  include IPAcommon

  [:user, :host, :service].each do |cat|
    [:add, :remove ].each do |action|
      meth       = "#{action}_#{cat}"
      group_meth = "#{meth}group".to_sym
      types = { :user    => [:user,:group],
                :host    => [:host,:hostgroup],
                :service => [:hbacsvc,:hbacsvcgroup], }

      define_method(meth) do |target,members|
        members = Array(members)
        post("#{@ipaclass}_#{meth}", [[target],{types[cat][0] => members}] )
      end
      define_method(group_meth) do |target,members|
        members = Array(members)
        post("#{@ipaclass}_#{meth}", [[target],{types[cat][1] => members}] )
      end

    end
  end

  def mod(target,opthash={})
    options={:all => true, :rights => true}
    opthash.each do |key,val|
      newkey = lookup.has_key?(key) ? lookup[key] : key
      options[newkey] = val
    end
    post("#{@ipaclass}_mod", [[target],options] )
  end

  @@lookup={
    :users            => :memberuser_user,
    :usergroups       => :memberuser_group,
    :hosts            => :memberhost_host,
    :hostgroups       => :memberhost_hostgroup,
    :services         => :memberservice_hbacsvc,
    :servicegroups    => :memberservice_hbacsvcgroup,
    :description      => :description,
    :anyuser          => :usercategory,
    :anyhost          => :hostcategory,
    :anyservice       => :servicecategory,
  }

  @@arrays=[:users, :usergroups, :hosts, :hostgroups, :services, :servicegroups, ]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end
 
end

class IPAhbacsvcgroup
  include IPAcommon
  include IPAmembers

  @@lookup=
    { :description => :description,
      :members     => :member_hbacsvc,
    }

  @@arrays=[:members, :member_hbacsvc]

  def lookup
    @@lookup
  end

  def prop_array?(key)
    @@arrays.include?(key) ? true : false
  end

end

class IPA

  require 'base64'
  require 'json'

  attr_reader :host, :hostgroup, :user, :group, :sudorule, :sudocmd, :sudocmdgroup, :hbacrule, :hbacsvc, :hbacsvcgroup


  def strict_encode64(bin)
    Base64.encode64(bin).split(/\n/).join('')
  end

  def strict_decode64(bin)
    Base64.decode64(bin.split(/\n/).join(''))
  end
  
  def initialize(host=nil)

    host = Socket.gethostbyname(Socket.gethostname).first if host.nil?

    @gsok    = false
    @uri     = URI.parse "https://#{host}/ipa/json"

    @extheader = { 
      "referer"       => "https://ipa.auto.local/ipa",
      "Content-Type"  => "application/json",
      "Accept"        => "applicaton/json",
    }
  
    @user         = IPAuser.new(self)
    @host         = IPAhost.new(self)
    @hostgroup    = IPAhostgroup.new(self)
    @group        = IPAgroup.new(self)
    @sudorule     = IPAsudorule.new(self)
    @sudocmd      = IPAsudocmd.new(self)
    @sudocmdgroup = IPAsudocmdgroup.new(self)
    @hbacrule     = IPAhbacrule.new(self)
    @hbacsvc      = IPAhbacsvc.new(self)
    @hbacsvcgroup = IPAhbacsvcgroup.new(self)

  end

  def create_robot

    require 'httpclient'
    require 'gssapi'
    @robot   = HTTPClient.new
    @gssapi  = GSSAPI::Simple.new(@uri.host, 'HTTP') # Get an auth token for HTTP/fqdn@REALM
    token    = @gssapi.init_context                  # Base64 encode it and shove it in the http header

    @extheader['Authorization'] = "Negotiate #{strict_encode64(token)}"

    @robot.ssl_config.set_trust_ca('/etc/ipa/ca.crt')

  end 

  def post(method,params) 

    create_robot unless @robot    

    payload = { "method" => method, "params" => params }
    resp    = @robot.post(@uri, JSON.dump(payload), @extheader)

    # lets look at the response header and see if kerberos liked our auth
    # only do this once since the context is established on success. 

    itok    = resp.header["WWW-Authenticate"].pop.split(/\s+/).last
    @gsok   = @gssapi.init_context(strict_decode64(itok)) unless @gsok

    if @gsok and resp.status == 200
      result = JSON.parse(resp.content)
      puts "--------OOOOOOOOOPS #{result['error']['message']}" if !result['error'].nil?
      result
    else
      puts "failed"
      nil
    end

  end

end
