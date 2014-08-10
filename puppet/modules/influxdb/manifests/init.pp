class influxdb {

  $pkg = "influxdb_latest_amd64.deb"
  $url = "http://s3.amazonaws.com/influxdb/${pkg}"
  
  exec { "download influxdb":
    command => "wget -O /tmp/${pkg} ${url}",
    creates => "/tmp/${pkg}",
  } ->

  package {"influxdb":
    ensure   => installed,
    provider => 'dpkg',
    source   => "/tmp/${pkg}",
  } ->

  service { "influxdb":
    ensure => running,
    enable => true,
  } ->

  exec { "create grafana db":
    command => "curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{\"name\": \"grafana\"}'",
    # multiple retries here as we wait for the service to start responding
    tries => 10,
    try_sleep => 1,
  } ->

  exec { "create default metrics db":
    command => "curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{\"name\": \"metrics\"}'",
  }
  
}
