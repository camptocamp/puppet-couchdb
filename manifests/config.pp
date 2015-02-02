# Class: couchdb::config
#
# This module manages couchdb configuration
#
# Parameters:
#
# [* admin_password *]
#   The password in plaintext to be used by CouchDB
class couchdb::config(
	$admin_username = 'admin'
  $admin_password = 'admin',
  $salt = 20,
  $key_length = 20,
  $iterations = 10,
  $database_dir = '/var/lib/couchdb',
  $users_db_public = false,
  $public_fields = undef,
) {

  $hashed_admin_password = str2saltedpbkdf2($admin_password, $salt, $key_length, $iterations)

  notify { $hashed_admin_password: }

  file { '/etc/couchdb/local.ini':
    ensure  => file,
    owner   => 'couchdb',
    group   => 'couchdb',
    content => template('couchdb/local.ini.erb'),
    require => Package['couchdb'],
    notify  => Service['couchdb'],
    mode    => '0700',
  }
}
