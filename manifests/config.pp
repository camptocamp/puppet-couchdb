# Class: couchdb::config
#
# This module manages couchdb configuration
#
# Parameters:
#
# [* users_db_public *]
#   Set this to true to allow all users to view user documents
#
# [* public_fields *]
#   World-viewable user document fields (requires setting users_db_public option to true)
#
# [* admin_username *]
#   The admin username to be configured for CouchDB
#
# [* admin_password *]
#   The password in plaintext to be used by CouchDB
#
# [* require_valid_user *]
#   Set this to true to only enable authenticated requests to the CouchDB
#
# [* authentication_realm *]
#   Set this to the name of the realm that CouchDB should output when sending the unauthorized response.
#
class couchdb::config(
  $users_db_public = undef,
  $public_fields = undef,
  $admin_username = $couchdb::params::admin_username,
  $admin_password = $couchdb::params::admin_password,
  $require_valid_user = $couchdb::params::require_valid_user,
  $authentication_realm = $couchdb::params::authentication_realm,
) inherits ::couchdb::params {

  $salt = 20
  $key_length = 20
  $iterations = 10
  $hashed_admin_password = str2saltedpbkdf2($admin_password, $salt, $key_length, $iterations)

  augeas { 'couchdb.local.ini':
    require => Package[couchdb],
    notify  => Service[couchdb],
    lens    => 'PHP.lns',
    incl    => '/etc/couchdb/local.ini',
    changes => [
      "set httpd/port ${couchdb::port}",
      "set httpd/bind_address ${couchdb::bind_address}",
      "set couch_httpd_auth/require_valid_user ${require_valid_user}",
      "set admins/${admin_username} ${hashed_admin_password}",
      $couchdb::authentication_realm ? {
        undef   => 'rm httpd/WWW-Authenticate',
        default => "set httpd/WWW-Authenticate \"Basic realm='${authentication_realm}'\"",
      },
      $public_fields ? {
        undef   => 'rm couch_httpd_auth/public_fields',
        default => "set couch_httpd_auth/public_fields ${public_fields}",
      },
      $users_db_public ? {
        undef   => 'rm couch_httpd_auth/users_db_public',
        default => "set couch_httpd_auth/users_db_public ${users_db_public}",
      },
    ],
  }

}
