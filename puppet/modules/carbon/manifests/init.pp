class carbon {

  package { [ postgresql, libpq-dev, python-psycopg2, graphite-carbon ]:
    ensure => latest;
  } ->
  
  augeas { "carbon log rotation":
    context => "/files/etc/carbon/carbon.conf",
    changes => [
      "set cache/ENABLE_LOGROTATION true",
    ],
  } ->

  file { "/etc/carbon/storage-schemas.conf" :
    ensure => file,    
    source => "puppet:///modules/carbon/storage-schemas.conf",
  } ->

  file { "/etc/carbon/storage-aggregation.conf" :
    ensure => file,    
    source => "puppet:///modules/carbon/storage-aggregation.conf",
  } ->

  augeas { "carbon cache enabled":
    context => "/files/etc/default/graphite-carbon",
    changes => [
      "set CARBON_CACHE_ENABLED true",
    ],
  } ->

  exec { "create DB user":
    user => "postgres",
    command => "psql -c \"CREATE USER graphite WITH PASSWORD 'password';\"",
  } ->

  exec { "create DB":
    user => "postgres",
    command => "psql -c \"CREATE DATABASE graphite WITH OWNER graphite;\"",
  } ->

  exec { "sync DB":
    command => "graphite-manage syncdb --noinput",
  } ->

  service { carbon-cache :
    enable  => true,
    ensure  => running,
  }
}
