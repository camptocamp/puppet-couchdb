class couchdb {
  case $::operatingsystem {
    Debian: {
      case $::lsbdistcodename {
        /lenny|squeeze|wheezy/: { include couchdb::debian }
        default: { fail "couchdb not available for ${::operatingsystem}/${::lsbdistcodename}" }
      }
    }
    RedHat: { include couchdb::redhat }
  }
}
