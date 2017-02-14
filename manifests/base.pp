class couchdb::base {

  package {'couchdb':
    ensure => present,
  }

  service {'couchdb':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['couchdb'],
  }

  augeas { '[couchdb.local.ini] set httpd parameters':
    require => Package[couchdb],
    notify  => Service[couchdb],
    lens    => 'PHP.lns',
    incl    => '/etc/couchdb/local.ini',
    changes => [
      "set httpd/port ${couchdb::port}",
      "set httpd/bind_address ${couchdb::bind_address}",
      "set couch_httpd_auth/require_valid_user ${couchdb::require_valid_user}",
      $couchdb::authentication_realm ? {
        undef   => 'rm httpd/WWW-Authenticate',
        default => "set httpd/WWW-Authenticate \"Basic realm='${couchdb::authentication_realm}'\"",
      },
    ],
  }

  if $couchdb::admin_password {
    augeas { '[couchdb.local.ini] set admin password if not set already':
      require => Package[couchdb],
      notify  => Service[couchdb],
      lens    => 'PHP.lns',
      incl    => '/etc/couchdb/local.ini',
      changes => [
        "set admins/admin ${couchdb::admin_password}",
      ],
      onlyif  => 'match admins/admin size == 0',
    }
  }
}
