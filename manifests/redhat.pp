class couchdb::redhat {
  class { '::couchdb::base':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }
}
