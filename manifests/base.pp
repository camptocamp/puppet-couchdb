class couchdb::base (
  $service_enable,
  $service_ensure,
) {

  package {'couchdb':
    ensure => present,
  }

  if $service_ensure == 'unmanaged' {
    $_service_ensure = undef
  } else {
    $_service_ensure = $service_ensure
  }

  service {'couchdb':
    enable    => $service_enable,
    ensure    => $_service_ensure,
    hasstatus => true,
    require   => Package['couchdb'],
  }

}
