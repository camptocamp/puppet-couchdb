class couchdb::base {

  package {["couchdb","libjs-jquery"]:
    ensure => present,
  }

  service {"couchdb":
    ensure    => running,
    hasstatus => true,
    require   => Package["couchdb"],
  }

}
