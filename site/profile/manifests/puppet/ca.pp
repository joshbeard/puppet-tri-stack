class profile::puppet::ca {

  include profile::params

  case $::clientcert {
    $profile::params::pe_puppetca01_fqdn: {
      $active_ca      = true
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
    }
    default: {
      $active_ca      = false
      $generate_certs = undef
    }
  }

  ## Add these to the autosign list
  ## Keep in mind, certs with additional names cannot be autosigned
  $autosign = [
    $profile::params::pe_console_certname,
    $profile::params::pe_puppetdb01_fqdn,
    $profile::params::pe_puppetdb02_fqdn,
  ]

  class { 'pe_server::ca':
    active_ca                 => $active_ca,
    autosign                  => $autosign,
    generate_certs            => $generate_certs,
    notify                    => Service['pe-httpd'],
  }

}
