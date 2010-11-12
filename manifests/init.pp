import "classes/*.pp"
  
class couchdb {
  case $operatingsystem {
    Debian: { 
      case $lsbdistcodename {
        lenny :  { include couchdb::debian }
        default: { fail "couchdb not available for ${operatingsystem}/${lsbdistcodename}"}
      }
    } 
  }
}
