class collectd {

  package { [ collectd, collectd-utils ]:
    ensure => latest;
  } ->
  
  exec { "stop collectd":
    command => "service collectd stop",
  } ->

  file { "/etc/collectd/collectd.conf" :
    ensure => file,    
    source => "puppet:///modules/collectd/collectd.conf",
  } ->

  service { "start collectd" :
    name => collectd,
    enable  => true,
    ensure  => running,
  }
}
