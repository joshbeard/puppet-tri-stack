##
## Profile for PuppetDB/PostgreSQL hosts
##
class profile::puppet::puppetdb {

  class { 'pe_server':
    ca_server                    => 'puppetca.vagrant.vm',
    export_puppetdb_whitelist    => false,
    export_console_authorization => false,
  }

  class { 'pe_server::puppetdb':
    postgres_database_host     => 'puppetdbpg.vagrant.vm',
  }

  ## Explicitly define whitelisted certificates
  pe_server::puppetdb::whitelist { $::settings::server: }
  pe_server::puppetdb::whitelist { $::clientcert: }
  pe_server::puppetdb::whitelist { 'pe-internal-dashboard': }
  pe_server::puppetdb::whitelist { 'puppetca01.vagrant.vm': }
  pe_server::puppetdb::whitelist { 'puppetca02.vagrant.vm': }

}
