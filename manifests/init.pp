# == Class: couchdb
#
# Install and configure CouchDB
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

  file_line { 'bind_address':
    path    => '/etc/couchdb/default.ini',
    line    => "bind_address = ${bind_address}",
    match   => '^bind_address =',
    after   => '^port =',
    require => Package['couchdb'],
  }
  file_line { 'port':
    path    => '/etc/couchdb/default.ini',
    line    => "port = ${port}",
    match   => '^port =',
    after   => '^\[httpd\]$',
    require => Package['couchdb'],
  }
}
