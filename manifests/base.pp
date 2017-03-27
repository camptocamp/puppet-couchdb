class couchdb::base (
  $service_enable,
  $service_ensure,
) {

  package {'couchdb':
    ensure => present,
  }

  service {'couchdb':
    enable    => $service_enable,
    ensure    => $service_ensure,
    hasstatus => true,
    require   => Package['couchdb'],
  }

}
