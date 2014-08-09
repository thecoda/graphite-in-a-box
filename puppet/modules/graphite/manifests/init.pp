class graphite {

  package { [ graphite-web, apache2, libapache2-mod-wsgi ]:
    ensure => latest;
  } ->
  
  exec { "init-db":
    command   => "graphite-manage syncdb --noinput",
    creates   => "/var/lib/graphite/graphite.db",
    require   => Package["graphite-web"],
  } ->

  file { "/var/lib/graphite/graphite.db" :
    owner => "_graphite",
    mode => "0664",
    notify => Exec["reload-apache2"],
  }

  file { "/etc/apache2/sites-available/apache2-graphite.conf" :
    ensure => present,    
    source => "puppet:///modules/graphite/apache2-graphite.conf",
    require => [ Package["graphite-web"], Package["apache2"], Package["libapache2-mod-wsgi"] ]
  } ->

  exec { "/usr/sbin/a2ensite apache2-graphite":
    unless => "/bin/readlink -e /etc/apache2/sites-enabled/apache2-graphite.conf",
    notify => Exec["reload-apache2"],
  } ->

  exec { "/usr/sbin/a2dissite 000-default":
    onlyif => "/bin/readlink -e /etc/apache2/sites-enabled/000-default.conf",
    notify => Exec["reload-apache2"],
  }

  exec { "reload-apache2":
    command => "service apache2 reload",
    refreshonly => true,
  }
}
