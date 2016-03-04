# == Class: couchdb
#
# Install and manage the CouchDB server
#
# === Parameters
#
# None
#
# === Examples
#
#  include ::couchdb
#
# === Authors
#
# CampToCamp SA <http://www.camptocamp.com/>
#
# === Copyright
#
# Copyright 2015 Bren Briggs, unless otherwise noted.
#

class couchdb (
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,
) inherits ::couchdb::params {

  case $::osfamily {
    'Debian': { include ::couchdb::debian }
    'RedHat': { include ::couchdb::redhat }
    default:  { fail "couchdb not available for ${::operatingsystem}" }
  }
}
