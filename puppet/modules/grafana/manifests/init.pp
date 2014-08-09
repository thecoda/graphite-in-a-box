class grafana($version = '1.6.1') {

  $grafana_url = "http://grafanarel.s3.amazonaws.com/grafana-${version}.tar.gz"
  
  exec { "download and extract":
    command => "wget -qO- $grafana_url | tar xzf - -C /opt",
    creates => "/opt/grafana-${version}",
  } ->

  file { "/opt/grafana-latest":
    ensure => link,
    target => "/opt/grafana-${version}",
    force => true,
  } ->

  file { "/opt/grafana-latest/config.js":
    ensure => file,
    source => "puppet:///modules/grafana/config.js",
  }

}
