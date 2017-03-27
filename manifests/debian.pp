class couchdb::debian (
  $service_ensure,
  $service_enable,
) {
  class { '::couchdb::base':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }

  package {'libjs-jquery':
    ensure => present,
  }

}
