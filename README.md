----------------

### ipa_group

Manages user groups within IPA.

Typically the properties are as they appear in the 'User Groups' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

The nonposix parameter, if changed, will destroy and re-create the group.

    ipa_group { 'editors':
      ensure      => 'present',
      description => 'Limited admins who can edit other users',
      gid         => '800200002',
      nonposix    => 'false',
    }

#### Parameters


description
: __String__ A description for the group. Defaults to the name

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

gid
: __Integer__ The gid of the group. Will be auto generated if absent

name
: __String__ The name of the group

nonposix
: __Boolean__ Whether this is a unix group or not. A true value will not create a GID for the group

  Valid values are `true`, `false`.

provider
: The specific backend to use for this `ipa_group`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_hbacrule

Manages Host Based Access Control rules within IPA.

Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Rules' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

Note :
  The parameters 'anyuser', 'anyhost', 'anyservice', if true, will set
  users and usergroups, hosts and hostgroups, services and servicegroups
  to an empty value respectively.

  This allows you to keep values in your manifest and override them

      ipa_hbacrule { 'puppet admins - client':
        ensure        => 'present',
        anyhost       => 'true',
        anyservice    => 'false',
        anyuser       => 'false',
        servicegroups => ['remote unix access'],
        usergroups    => ['puppet_admins'],
      }

#### Parameters


anyhost
: __Boolean__ Whether this hbac rule applies to all hosts. Overrides hosts/hostgroups

  Valid values are `true`, `false`.

anyservice
: __Boolean__ Whether this hbac rule applies to all services. Overrides services/servicegroups

  Valid values are `true`, `false`.

anyuser
: __Boolean__ Whether this hbac rule applies to all users. Overrides users/usergroups

  Valid values are `true`, `false`.

description
: __String__ A description for the hbac rule. Defaults to the name of the hbac rule

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

hostgroups
: __Array of strings__ A list of hostgroups `ipa_hostgroup` that this hbac rule applies to

hosts
: __Array of strings__ a list of hosts `ipa_host` that this hbac rule applies to

name
: __String__ The name of the hbac rule

provider
: The specific backend to use for this `ipa_hbacrule`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :

servicegroups
: __Array of strings__ A list of servicegroups `ipa_hbacsvcgroup` that this hbac rule applies to

services
: __Array of strings__ A list of services `ipa_hbacsvc` that this hbac rule applies to

usergroups
: __Array of strings__ a list of usergroups `ipa_groups` that this hbac rule applies to

users
: __Array of strings__ a list of users `ipa_user` that this hbac rule applies to




----------------

### ipa_hbacsvc

Manages Host Based Access Control servcies within IPA.

Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Services' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    ipa_hbacsvc { 'sudo':
      ensure      => 'present',
      description => 'sudo',
    }

#### Parameters


description
: __String__ A description for the service. Defaults to the name of the service

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

name
: __String__  The name of the service

provider
: The specific backend to use for this `ipa_hbacsvc`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_hbacsvcgroup

Manages Host Based Access Control service groups within IPA.

Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Service Groups' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    ipa_hbacsvcgroup { 'remote unix access':
      ensure      => 'present',
      description => 'ssh / sudo / ftp',
      members     => ['sshd', 'sudo'],
    }

#### Parameters


description
: __String__ A description for the service group. Defaults to the name of the service group

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

members
: __Array of strings__ A list of services `ipa_hbacsvc` that constitute the service group

name
: __String__ The name of the service groups

provider
: The specific backend to use for this `ipa_hbacsvcgroup`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_host

Manages host details within IPA.

This type is most useful when collected on the IPA server from exported resources.

Typically the properties are as they appear in the 'Hosts' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

The ip_address parameter is used only on creation to populate DNS

    ipa_host { 'ipa.auto.local':
      ensure           => 'present',
      description      => 'Primary IPA server',
      locality         => 'Timbuktu',
      location         => 'datahall 1 rack 2',
      managedby        => "ipa.$::domain",
      operating_system => "$::operatingsystem $::operatingsystemrelease",
      platform         => $::architecture,
    }

#### Parameters


description
: __String__ A description for the server. Defaults to the name of the host

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

hostgroups
: __Array of strings__ A list of hostgroups this server belongs to

ip\_address
: __String__ The IP address of the server. A sane default is `$::ipaddress`

locality
: __String__ Locality of the server

location
: __String__ Location of the server

managedby
: __Array of strings__ A list of ipa servers managing this server. Typically this is your IPA server

name
: __String__ The fully qualified hostname

operating\_system
: __String__  OS of the server. A sane value is `"$::operatingsystem $::operatingsystemrelease"`

platform
: __String__  Platform of the server. A sane value is `$::architecture`

provider
: The specific backend to use for this `ipa_host`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_hostgroup

Manages hostgroups within IPA.

Typically the properties are as they appear in the 'Host Groups' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    ipa_hostgroup { 'puppet_servers':
      ensure      => 'present',
      description => 'Puppet Servers',
    }

#### Parameters


description
: __String__ A description for the hostgroup. Defaults to the name of the hostgroup

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

name
: __String__  The name of hte hostgroup

provider
: The specific backend to use for this `ipa_hostgroup`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_sudocmd

Manages Sudo commands within IPA.

Typically the properties are as they appear in the 'Sudo -> Sudo Commands' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    ipa_sudocmd { '/etc/init.d/puppet':
      ensure => 'present',
    }

#### Parameters


description
: __String__ A description for the sudo command. Defaults to the name of the sudo command

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

name
: __String__ The name of the sudo command. This is the fully qualified path to the binary. Wildcards are allowed

provider
: The specific backend to use for this `ipa_sudocmd`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_sudocmdgroup

Manages Sudo command groups within IPA.

Typically the properties are as they appear in the 'Sudo -> Sudo Command Groups' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

    ipa_sudocmdgroup { 'puppet commands':
      ensure      => 'present',
      description => 'Stuff for puppet',
      members     => ['/etc/init.d/puppet', '/usr/bin/pupet'],
    }

#### Parameters


description
: __String__ A description ffor the sudo command group. Defaults to the name of the sudo command group

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

members
: __Array of strings__ A list of sudo commands `ipa_sudocmd` that constitute the sudo command group

name
: __String__  The name of the sudo command group

provider
: The specific backend to use for this `ipa_sudocmdgroup`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :




----------------

### ipa_sudorule

Manages Sudo rules within IPA.

Typically the properties are as they appear in the 'Host Based Access Control -> HBAC Rules' section of the web interface,
lowercased, with underscores replacing spaces. Properties that take an array are pluralized.

Note :
  The parameters 'anyuser', 'anyhost', 'anycommand', if true, will set
  users and usergroups, hosts and hostgroups, allow/deny_commands and allow/deny_commandgroups
  to an empty value respectively.

  The parameters 'anyrunasuser' and 'anyrunasgroup', if true, will set
  runasusers / runasusergroups / runasgroups to an empty value

  This allows you to keep values in your manifest and override them

    ipa_sudorule { 'puppet administration - client':
      ensure              => 'present',
      allow_commandgroups => ['puppet commands'],
      anycommand          => 'false',
      anyhost             => 'true',
      anyrunasgroup       => 'false',
      anyrunasuser        => 'false',
      anyuser             => 'false',
      options             => ['!authenicate'],
      usergroups          => ['puppet_admins'],
    }

#### Parameters


allow\_commandgroups
: __Array of strings__ A list of commandgroups `ipa_sudocmdgroup` that the sudo rule allows to be run

allow\_commands
: __Array of strings__  A list of commands `ipa_sudocmd` that the sudo rule allows to be run

anycommand
: __Boolean__ Whether this sudo rule applies to all commands. Overrides allow/deny_command(group)s

  Valid values are `true`, `false`.

anyhost
: __Boolean__ Whether this sudo rule applies to all hosts. Overrides hosts/hostgroups

  Valid values are `true`, `false`.

anyrunasgroup
: __Boolean__ Whether this sudo rule can run as any group. Overrides runasuser/runasusergroups/runasgroup

  Valid values are `true`, `false`.

anyrunasuser
: __Boolean__ Whether this sudo rule can run as any user. Overrides runasuser/runasusergroups/runasgroup

  Valid values are `true`, `false`.

anyuser
: __Boolean__ Whether this sudo rule applies to all users. Overrides users/usergroups

  Valid values are `true`, `false`.

deny\_commandgroups
: __Array of strings__  A list of commandgroups `ipa_sudocmdgroup` that the sudo rule prevents from running

deny\_commands
: __Array of strings__ A list of commands `ipa_sudocmd` that the sudo rule prevents from running

description
: __String__ A description for the sudo rule. Defaults to hte name of the sudo rule

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

hostgroups
: __Array of strings__ A list of hostgroups `ipa_hostgroup` that the sudo rule applies to

hosts
: __Array of strings__ A list of hosts `ipa_host` that the sudo rule applies to

name
: __String__ The name of the sudo rule

options
: __Array of strings__ A list of options that the sudo rule. i.e. `["!authenticatei"]`

provider
: The specific backend to use for this `ipa_sudorule`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :

runasgroups
: __Array of strings__  A list of usergroups `ipa_group` that the sudo commands in the rule can be run as

runasusergroups
: __Array of strings__ A list of usergroups `ipa_groups` that contain users that the sudo commands in the rule can be run as

runasusers
: __Array of strings__ A list of users `ipa_user` that the sudo commands in the rule can be run as

usergroups
: __Array of strings__ A list of usergroups `ipa_group` whose users are permitted to run the commands in the sudo rule

users
: __Array of strings__ A list of users `ipa_user` permitted to run the commands in the sudo rule




----------------

### ipa_user

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

#### Parameters


car\_license
: __String__ The users car license plate number

city
: __String__ The users city of residence

display\_name
: __String__

ensure
: Whether the resource should exist or not

  Valid values are `present`, `absent`.

fax\_numbers
: __Array of strings__ Fax numbers for the user. Single values are converted to arrays

first\_name
: __String__

full\_name
: __String__

gecos
: __String__ The string that will appear in the comment field on unix systems for the user

gid
: __Integer__ The user ID. If unset, will be inherited from the default group

home\_directory
: __String__ The users default login shell. i.e. /bin/bash. Defaults to /home/<user>

initials
: __String__

last\_name
: __String__

login\_shell
: __String__ The users default login shell. i.e. /bin/bash

mail
: __String__ The users email address. Defaults to <user>@domain

manager
: __String__ The users manager. This is an existing user

mobile\_numbers
: __Array of strings__ Mobile numbers for the user. Single values are converted to arrays

org\_unit
: __String__ The users organizational unit. Typically the department

pager\_numbers
: __Array of strings__ Pager numbers for the user. Single values are converted to arrays

password
: __String__ The initial password for hte account

provider
: The specific backend to use for this `ipa_user`
  resource. You will seldom need to specify this --- Puppet will usually
  discover the appropriate provider for your platform.Available providers are:

  ipa
  :

ssh\_public\_keys
: __Array of strings__ An array of ssh public keys for the user. This allows login without passwords providing the private key is present

state
: __String__  The users state of residence

street\_address
: __String__ The users street address. i.e. 57 Mount Pleasant Street

telephone\_numbers
: __Array of strings__ Telephone numbers for the user. Single values are converted to arrays

title
: __String__ Users title, i.e. Mr, Ms

uid
: __Integer__ The user ID. If unset, will be automatically generated

user
: (**Namevar:** If omitted, this parameter's value defaults to the resource's title.)

  __String__ The username, i.e. jhughesj

usergroups
: __Array of strings__ An array of groups that the user belongs to

zip
: __String__ The users zip code / post code




----------------

