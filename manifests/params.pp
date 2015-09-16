class couchdb::params {

  $bind_address = $::couchdb_bind_address ? {
    ''      => '127.0.0.1',
    default => $::couchdb_bind_address,
  }

  $port = $::couchdb_port ? {
    ''      => '5984',
    default => $::couchdb_port,
  }

  $backupdir = '/var/local/couchdb-backups'

  $admin_username = $::couchdb_admin_username ? {
    ''      => undef,
    default => $::couchdb_admin_username,
  }

  $admin_password = $::couchdb_admin_password ? {
    ''      => undef,
    default => $::couchdb_admin_password,
  }

  $require_valid_user = $::couchdb_require_valid_user ? {
    ''      => false,
    default => $::couchdb_require_valid_user,
  }

  $authentication_realm = $::couchdb_authentication_realm ? {
    ''      => undef,
    default => $::couchdb_authentication_realm,
  }

  $public_fields = $::couchdb_public_fields ? {
    ''      => undef,
    default => $::couchdb_public_fields,
  }

}
