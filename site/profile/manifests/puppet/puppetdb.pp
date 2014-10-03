##
## Profile for PuppetDB/PostgreSQL hosts
##
class profile::puppet::puppetdb {

  include profile::params

  class { 'pe_server':
    ca_server                    => $profile::params::pe_puppetca_fqdn,
    puppet_server                => $profile::params::pe_puppetmaster_fqdn,
    export_puppetdb_whitelist    => false,
  }

  class { 'pe_server::puppetdb':
    postgres_database_host     => $profile::params::pe_puppetdbpg_fqdn,
  }

  ## Explicitly define whitelisted certificates
  pe_server::puppetdb::whitelist { $profile::params::pe_puppetdb_whitelist: }

}
