###############################################################################
## This is a little unusual.  We're including a class from a component module
## here so we can use variables from it globally.  However, this is for the
## Puppet architecture.  We need to set top-scope variables from it.
include profile::params

## Mcollective "servers"
## Set it here so we're certain to have it available as a top-scope variable
$fact_stomp_server = join($profile::params::pe_stomp_servers, ',')

## ActiveMQ brokers
## Set it here so we're certain to have it available as a top-scope variable
$activemq_brokers = join($profile::params::pe_activemq_brokers, ',')

##
## TODO: Get rid of this.
## Yeah, this is gross.  We want to classify the "core" Puppet servers right
## away so we can bootstrap them off a master when needed.  We also want to
## pull their actual certname from the profile::params class.
##
case $::clientcert {
  $profile::params::pe_puppetca01_fqdn: {
    include role::puppet::ca
  }
  $profile::params::pe_puppetca02_fqdn: {
    include role::puppet::ca
  }
  $profile::params::pe_puppetdb01_fqdn: {
    include role::puppet::puppetdb
  }
  $profile::params::pe_puppetdb02_fqdn: {
    include role::puppet::puppetdb
  }
  $profile::params::pe_puppetconsole01_fqdn: {
    include role::puppet::console
  }
  $profile::params::pe_puppetconsole02_fqdn: {
    include role::puppet::console
  }
}

###############################################################################

## Use the generic CNAME for 'puppetmaster' for the filebucket
filebucket { 'main':
  server => $profile::params::puppetmaster_fqdn,
  path   => false,
}

File { backup => 'main' }

## Resource default for the vcsrepo type.  Keep it from complaining that a
## default provider isn't specified.
Vcsrepo {
  provider => 'git',
}

## PE 3.3 introduces 'allow_virtual' to the package resource type, which
## will cause warnings.  Set this to true to remove the warnings.
Package {
  allow_virtual => true,
}

###############################################################################
## Below this line is where your own trickery will go
###############################################################################

node default {

}
