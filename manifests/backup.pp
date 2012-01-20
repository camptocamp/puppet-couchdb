class couchdb::backup {

  include couchdb::params

  # used in ERB templates
  $bind_address = $couchdb::params::bind_address
  $port = $couchdb::params::port
  $backupdir = $couchdb::params::backupdir

  file {$couchdb::params::backupdir:
    ensure  => directory,
    mode    => 755,
    require => Package["couchdb"],
  }

  file { "/usr/local/sbin/couchdb-backup.py":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("couchdb/couchdb-backup.py.erb"),
    require => File[$couchdb::params::backupdir],
  }

  cron { "couchdb-backup":
    command => "/usr/local/sbin/couchdb-backup.py 2> /dev/null",
    hour    => 3,
    minute  => 0,
    require => File["/usr/local/sbin/couchdb-backup.py"],
  }

  # note: python-couchdb >= 0.8 required, which is found in debian wheezy.
  package { ["python-couchdb", "python-simplejson"]:
    ensure => present,
    before => File["/usr/local/sbin/couchdb-backup.py"],
  }

}
