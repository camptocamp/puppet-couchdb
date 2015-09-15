class couchdb (
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,
  $admin_password = $couchdb::params::admin_password,
  $require_valid_user = $couchdb::params::require_valid_user,
  $authentication_realm = $couchdb::params::authentication_realm,
) inherits ::couchdb::params {

  case $::osfamily {
    'Debian': { include ::couchdb::debian }
    'RedHat': { include ::couchdb::redhat }
    default:  { fail "couchdb not available for ${::operatingsystem}" }
  }
}
