class graphitepoller {
 
  file { "/etc/init/graphite-poller.conf":
    ensure => file,
    source => "puppet:///modules/graphitepoller/graphite-poller.conf",
  } ->

  service { graphite-poller :
    enable  => true,
    ensure  => running,
    require => Class["graphite"],
  }

}
