class couchdb::params {

  $bind_address = $couchdb_bind_address ? {
    ''      => '127.0.0.1',
    default => $couchdb_bind_address,
  }

  $port = $couchdb_port ? {
    ''      => '5984',
    default => $couchdb_port,
  }

  $backupdir = $couchdb_backupdir ? {
    ''      => '/var/backups/couchdb',
    default => $couchdb_backupdir,
  }

}
