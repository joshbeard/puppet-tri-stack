###############################################################################
## This is a little unusual.  We're including a class from a component module
## here so we can use variables from it globally.  However, this is for the
## Puppet architecture.  We need to set top-scope variables from it.
include profile::params

## Mcollective "servers"
$fact_stomp_server = join($profile::params::pe_stomp_servers, ',')

## ActiveMQ brokers
$activemq_brokers = join($profile::params::pe_activemq_brokers, ',')

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

filebucket { 'main':
  server => $profile::puppetmaster_fqdn,
  path   => false,
}

File { backup => 'main' }

## Resource default for the vcsrepo type.  Keep it from complaining.
Vcsrepo {
  provider => 'git',
}

## PE 3.3 introduces 'allow_virtual' to the package resource type, which
## will cause warnings.  Set this to true to remove the warnings.
Package {
  allow_virtual => true,
}

###############################################################################

node default {

}
