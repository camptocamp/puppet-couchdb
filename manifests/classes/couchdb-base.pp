class couchdb::base {

  package {"couchdb":
    ensure => present,
  }

  service {"couchdb":
    ensure    => running,
    hasstatus => true,
    require   => Package["couchdb"],
  }

}
