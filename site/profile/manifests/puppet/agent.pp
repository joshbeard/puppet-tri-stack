class profile::puppet::agent {

  class { 'pe_server':
    ca_server                    => $profile::params::pe_puppetca_fqdn,
    export_puppetdb_whitelist    => false,
    export_console_authorization => false,
  }

}
