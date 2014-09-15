class profile::puppet::agent {

  include profile::params

  class { 'pe_server':
    is_master                    => false,
    ca_server                    => $profile::params::pe_puppetca_fqdn,
    change_filebucket            => true,
    filebucket_server            => $profile::params::pe_puppetmaster_fqdn,
    export_puppetdb_whitelist    => false,
    export_console_authorization => false,
  }

}
