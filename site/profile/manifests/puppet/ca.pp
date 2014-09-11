class profile::puppet::ca {

  include profile::params

  ## Determine if this is an active CA or not, based on the clientcert
  ## Non-active CAs will have their CA functionality disabled
  $active_ca = $::clientcert ? {
    $profile::params::pe_puppetca01_fqdn => true,
    default                              => false,
  }

  ## Add these to the autosign list
  ## Keep in mind, certs with additional names cannot be autosigned
  $autosign = [
    $profile::params::pe_console_certname,
    $profile::params::pe_puppetdb01_fqdn,
  ]

  ## Additional certificates to create on the CA
  ## In this case, we want to create certs for puppetca02, since ca01 is the
  ## canonical source.
  $generate_certs = {
    "${profile::params::pe_puppetca02_fqdn}" => {
      dns_alt_names                          => [
        $profile::params::pe_puppetca02_fqdn,
        $profile::params::pe_puppetca01_fqdn,
        $profile::params::pe_puppetca_fqdn,
        $profile::params::pe_puppetmaster_fqdn,
        $profile::params::pe_puppetca02_hostname,
        $profile::params::pe_puppetca01_hostname,
        $profile::params::pe_puppetca_hostname,
        $profile::params::pe_puppetmaster_hostname,
      ],
    }
  }

  class { 'pe_server':
    is_master                    => true,
    ca_server                    => $profile::params::pe_puppetca_fqdn,
    export_console_authorization => false,
    export_puppetdb_whitelist    => false,
  }

  class { 'pe_server::ca':
    active_ca                 => $active_ca,
    autosign                  => $autosign,
    generate_certs            => $generate_certs,
    notify                    => Service['pe-httpd'],
  }

  class { 'pe_server::mcollective':
    primary            => $profile::params::pe_puppetca01_fqdn,
    shared_credentials => true,
  }

  ## Manage this service so we can notify it
  service { 'pe-httpd':
    ensure => 'running',
  }
}
