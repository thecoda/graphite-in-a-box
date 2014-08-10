class statsd {

  package { "nodejs" :
    ensure => "present"
  } ->

  file { "/etc/statsd/" :
    ensure => directory,   
  } ->

  file { "/etc/statsd/localConfig.js" :
    ensure => file,    
    source => "puppet:///modules/statsd/localConfig.js",
  } ->

  file { "/usr/share/statsd" :
    ensure => directory,
  } ->

  file { "/usr/share/statsd/backends" :
    ensure => directory,
  } ->

  file { "/usr/share/statsd/backends/statsd-influxdb-backend" :
    ensure => directory,
    source => "puppet:///modules/statsd/statsd-influxdb-backend",
    recurse => true,
  } ->

  package { "statsd" :
    provider => "dpkg",
    source => "/vagrant/statsd_0.6.0-1_all.deb",
    ensure => installed,
  } ->

  service { "statsd" :
    enable  => true,
    ensure  => running,
    require => Class["influxdb"]
  }


}