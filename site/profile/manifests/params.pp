class profile::params {
  #############################################################################
  ## For the PE servers
  #############################################################################
  $pe_puppetca_hostname               = 'puppetca'
  $pe_puppetca01_hostname             = 'puppetca01'
  $pe_puppetca02_hostname             = 'puppetca02'
  $pe_puppetca01_fqdn                 = "${pe_puppetca01_hostname}.${::domain}"
  $pe_puppetca02_fqdn                 = "${pe_puppetca02_hostname}.${::domain}"
  $pe_puppetca_fqdn                   = "${pe_puppetca_hostname}.${::domain}"

  $pe_puppetconsole_hostname          = 'puppetconsole'
  $pe_puppetconsole01_hostname        = 'puppetconsole01'
  $pe_puppetconsole02_hostname        = 'puppetconsole02'
  $pe_puppetconsole_fqdn              = "${pe_puppetconsole_hostname}.${::domain}"
  $pe_puppetconsole01_fqdn            = "${pe_puppetconsole01_hostname}.${::domain}"
  $pe_puppetconsole02_fqdn            = "${pe_puppetconsole02_hostname}.${::domain}"

  $pe_puppetdb_hostname               = 'puppetdb'
  $pe_puppetdb01_hostname             = 'puppetdb01'
  $pe_puppetdb02_hostname             = 'puppetdb02'
  $pe_puppetdb_fqdn                   = "${pe_puppetdb_hostname}.${::domain}"
  $pe_puppetdb01_fqdn                 = "${pe_puppetdb01_hostname}.${::domain}"
  $pe_puppetdb02_fqdn                 = "${pe_puppetdb02_hostname}.${::domain}"

  $pe_puppetmaster_hostname           = 'puppetmaster'
  $pe_puppetmaster_fqdn               = "${pe_puppetmaster_hostname}.${::domain}"

  $pe_puppetconsolepg_hostname        = 'puppetconsolepg'
  $pe_puppetconsolepg_fqdn            = "${pe_puppetconsolepg_hostname}.${::domain}"

  $pe_puppetdbpg_hostname             = 'puppetdbpg'
  $pe_puppetdbpg_fqdn                 = "${pe_puppetdbpg_hostname}.${::domain}"

  $pe_puppetconsole_pgdb_password     = 'hunter2'
  $pe_puppetconsoleauth_pgdb_password = 'hunter2'
  $pe_puppetdb_pgdb_password          = 'hunter2'
  $pe_console_certname                = 'pe-internal-dashboard'

  ## PuppetDB Whitelist
  $pe_puppetdb_whitelist = [
    $::clientcert,
    $pe_console_certname,
    $pe_puppetca01_fqdn,
    $pe_puppetca02_fqdn,
    "puppetmaster01.${::domain}",
  ]

  ## Console authorizations
  $pe_console_authorizations = {
    'pe-internal-dashboard' => {
      'role'                => 'read-write'
    },
    "${::clientcert}"       => {
      'role'                => 'read-write'
    },
    "${pe_puppetca01_fqdn}" => {
      'role'                => 'read-write'
    },
    "${pe_puppetca02_fqdn}" => {
      'role'                => 'read-write'
    },
    "puppetmaster01.${::domain}" => {
      'role'                => 'read-write'
    },
  }

  ## Mcollective
  $pe_stomp_servers = [
    $pe_puppetca01_fqdn,
    $pe_puppetca02_fqdn,
    "puppetmaster01.${::domain}",
  ]

  $pe_activemq_brokers = [
    $pe_puppetca01_fqdn,
    $pe_puppetca02_fqdn,
    "puppetmaster01.${::domain}",
  ]

  $control_repo_address               = 'https://github.com/joshbeard/ppuppet.git'
  #############################################################################
}
