# Class: couchdb::config
#
# This class manages the couchdb configuration
#
class couchdb::config {

  $salt = 20
  $key_length = 20
  $iterations = 10
  $hashed_admin_password = str2saltedpbkdf2($couchdb::admin_password, $salt, $key_length, $iterations)

  $users_db_public = $couchdb::public_fields ? {
    undef   => undef,
    default => true,
  }

  augeas { 'couchdb.local.ini':
    require => Package[couchdb],
    notify  => Service[couchdb],
    lens    => 'PHP.lns',
    incl    => '/etc/couchdb/local.ini',
    changes => [
      "set httpd/port ${couchdb::port}",
      "set httpd/bind_address ${couchdb::bind_address}",
      "set couch_httpd_auth/require_valid_user ${couchdb::require_valid_user}",
      "set admins/${couchdb::admin_username} ${hashed_admin_password}",
      $couchdb::authentication_realm ? {
        undef   => 'rm httpd/WWW-Authenticate',
        default => "set httpd/WWW-Authenticate \"Basic realm='${couchdb::authentication_realm}'\"",
      },
      $couchdb::public_fields ? {
        undef   => 'rm couch_httpd_auth/public_fields',
        default => "set couch_httpd_auth/public_fields ${couchdb::public_fields}",
      },
      $users_db_public ? {
        undef   => 'rm couch_httpd_auth/users_db_public',
        default => "set couch_httpd_auth/users_db_public ${users_db_public}",
      },
    ],
  }

}
