class profile::puppet::master {

  ## Global variables for PE configuration
  include profile::params

  ## Mcollective servers
  $stomp_servers = join($profile::params::pe_stomp_servers, ',')

  ## Manage various architecture settings, such as CA settings
  class { 'pe_server':
    ca_server                    => $profile::params::pe_puppetca_fqdn,
    puppet_server                => $profile::params::puppetmaster_fqdn,
    export_puppetdb_whitelist    => false,
  }

  class { 'pe_server::master': }


  ## Configure Mcollective - we want to share credentials and provide multiple
  ## brokers
  class { 'pe_server::mcollective':
    primary            => $profile::params::pe_puppetca01_fqdn,
    shared_credentials => true,
    activemq_brokers   => $profile::params::pe_activemq_brokers,
  }

  ## Set the stomp servers as a top-scope variable in site.pp
  file_line { 'site_stomp_servers':
    ensure => 'present',
    line   => "\$fact_stomp_server = '${stomp_servers}'",
    path   => "${::settings::confdir}/manifests/site.pp",
  }

  ## Configure r10k
  class { 'r10k':
    sources       => {
      'control'   => {
        'remote'  => $profile::params::control_repo_address,
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      },
    },
    purgedirs         => [ "${::settings::confdir}/environments" ],
    manage_modulepath => false,
    mcollective       => false,
    notify            => Service['pe-httpd'],
  }

  ## Ensure an environments directory exists
  file { "${::settings::confdir}/environments":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  ## Configure Puppet's base module path - where can it find 'global' modules
  ini_setting { 'basemodulepath':
    ensure  => 'present',
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'basemodulepath',
    value   => "${::settings::confdir}/modules:/opt/puppet/share/puppet/modules",
    notify  => Service['pe-httpd'],
  }

  ## Configure Puppet's environment path - where can it find environments
  ini_setting { 'environmentpath':
    ensure => 'present',
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => "${::settings::confdir}/environments",
    notify  => Service['pe-httpd'],
  }

  ## Manage the pe-httpd service here, so we can notify it
  service { 'pe-httpd':
    ensure => 'running',
    enable => true,
  }

}
