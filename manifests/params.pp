class couchdb::params {

  if defined('$couchdb_bind_address') {
    $bind_address = $::couchdb_bind_address ? {
      ''      => '127.0.0.1',
      default => $::couchdb_bind_address,
    }
  } else {
    $bind_address = '127.0.0.1'
  }

  if defined('$couchdb_port') {
    $port = $::couchdb_port ? {
      ''      => '5984',
      default => $::couchdb_port,
    }
  } else {
    $port = '5984'
  }

  $backupdir = '/var/local/couchdb-backups'

  $admin_password = $::couchdb_admin_password ? {
    '' => undef,
    default => $::couchdb_admin_password,
  }

  $require_valid_user = $::couchdb_require_valid_user ? {
    '' => false,
    default => $::couchdb_require_valid_user,
  }

  $authentication_realm = $::couchdb_authentication_realm ? {
    '' => undef,
    default => $::couchdb_authentication_realm,
  }

}
