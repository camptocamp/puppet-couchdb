class couchdb::backup {

  require couchdb
  require python

  # used in ERB templates
  $bind_address = $couchdb::bind_address
  validate_re($bind_address, '^\S+$')
  $port = $couchdb::port
  validate_re($port, '^[0-9]+$')
  $backupdir = $couchdb::backupdir
  validate_absolute_path($backupdir)

  $admin_user = $couchdb::admin_username ? {
    undef => 'None',
    default => "'${couchdb::admin_username}'",
  }

  $admin_password = $couchdb::admin_password ? {
    undef => 'None',
    default => "'${couchdb::admin_password}'",
  }

  file {$backupdir:
    ensure  => directory,
    mode    => '0755',
    require => Package['couchdb'],
  }

  $password_set = $couchdb::admin_password ? {
    undef   => true,
    default => false,
  }

  file { '/usr/local/sbin/couchdb-backup.py':
    ensure    => file,
    owner     => root,
    group     => root,
    mode      => '0755',
    content   => template('couchdb/couchdb-backup.py.erb'),
    show_diff => $password_set,
    require   => File[$backupdir],
  }

  cron { 'couchdb-backup':
    command => '/usr/local/sbin/couchdb-backup.py 2> /dev/null',
    hour    => 3,
    minute  => 0,
    require => File['/usr/local/sbin/couchdb-backup.py'],
  }

  python::pip { ['couchdb', 'simplejson']:
    proxy => hiera('https_proxy'),
  }

}
