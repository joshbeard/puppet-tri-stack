class profile::puppet::agent {

  include profile::params

  ## Use the pe_server module to manage some common Puppet settings
  class { 'pe_server':
    ca_server                    => $profile::params::pe_puppetca_fqdn,
    puppet_server                => $profile::params::pe_puppetmaster_fqdn,
    export_puppetdb_whitelist    => false,
    export_console_authorization => false,
  }

}
