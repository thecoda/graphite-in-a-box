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

  package { "statsd" :
    provider => "dpkg",
    source => "/vagrant/statsd_0.6.0-1_all.deb",
    ensure => installed,
  }

}