class couchdb::debian inherits couchdb::base {

  package {"libjs-jquery":
    ensure => present,
  }
  
}
