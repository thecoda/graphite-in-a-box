class elasticsearch($version = '1.3.1') {

  $pkg = "elasticsearch-${version}.deb"
  $url = "https://download.elasticsearch.org/elasticsearch/elasticsearch/${pkg}"

  exec { "download elasticsearch":
    command => "wget -O /tmp/${pkg} ${url}",
    creates => "/tmp/${pkg}",
  } ->

  package { "openjdk-7-jre-headless":
    ensure => latest
  } ->

  package {"elasticsearch":
    ensure   => installed,
    provider => 'dpkg',
    source   => "/tmp/${pkg}",
    require  => Exec["apt-get-update"]
  } ->

  service { "elasticsearch":
    ensure => running,
    enable => true,
  }

}
