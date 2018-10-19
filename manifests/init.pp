class couchdb (
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,
  $service_ensure = $couchdb::params::service_ensure,
  $service_enable = $couchdb::params::service_enable,
) inherits ::couchdb::params {

  case $::osfamily {
    'Debian': {
      class { '::couchdb::debian':
        service_ensure => $service_ensure,
        service_enable => $service_enable,
      }
    }
    'RedHat': {
      class { '::couchdb::redhat':
        service_ensure => $service_ensure,
        service_enable => $service_enable,
      }
    }
    default:  { fail "couchdb not available for ${::operatingsystem}" }
  }
}
