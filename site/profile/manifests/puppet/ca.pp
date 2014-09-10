class profile::puppet::ca {

  ## Determine if this is an active CA or not, based on the clientcert
  ## Non-active CAs will have their CA functionality disabled
  $active_ca = $::clientcert ? {
    /puppetca01.*/ => true,
    default      => false,
  }

  ## Add these to the autosign list
  ## Keep in mind, certs with additional names cannot be autosigned
  $autosign = [
    'pe-internal-dashboard',
    'puppetdb01.vagrant.vm',
    '*.vagrant.vm',
  ]

  ## Additional certificates to create on the CA
  ## In this case, we want to create certs for puppetca02, since ca01 is the
  ## canonical source.
  $generate_certs = {
    'puppetca02.vagrant.vm' => {
      dns_alt_names         => [
        'puppetca01.vagrant.vm',
        'puppetca01',
        'puppetca02',
        'puppetca.vagrant.vm',
        'puppetca',
        'puppetmaster.vagrant.vm',
        'puppetmaster',
      ],
    }
  }

  class { 'pe_server':
    is_master                    => true,
    ca_server                    => 'puppetca.vagrant.vm',
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
    primary            => 'puppetca01.vagrant.vm',
    shared_credentials => true,
  }

  ## Manage this service so we can notify it
  service { 'pe-httpd':
    ensure => 'running',
  }
}
