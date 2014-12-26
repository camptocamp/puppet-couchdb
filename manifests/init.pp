class couchdb (
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,
) inherits ::couchdb::params {

  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        /lenny|squeeze|wheezy/: { include ::couchdb::debian }
        default: {
          fail(
            "couchdb unavailable for ${::operatingsystem}/${::lsbdistcodename}"
          )
        }
      }
    }
    'RedHat':  { include ::couchdb::redhat }
    default: { fail "couchdb not available for ${::operatingsystem}" }
  }
}
