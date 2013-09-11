class couchdb (
  $bind_address = $couchdb::bind_address,
  $port = $couchdb::port,
  $backupdir = $couchdb::backupdir,
) inherits ::couchdb::params {

  case $::operatingsystem {
    Debian: {
      case $::lsbdistcodename {
        /lenny|squeeze|wheezy/: { include ::couchdb::debian }
        default: { fail "couchdb not available for ${::operatingsystem}/${::lsbdistcodename}" }
      }
    }
    RedHat: { include ::couchdb::redhat }
  }
}
