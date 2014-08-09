Exec {
  path => ["/usr/bin", "/usr/sbin", '/bin']
}

Exec["apt-get-update"] -> Package <| |>

exec { "apt-get-update" :
  command => "/usr/bin/apt-get update",
  require => File["/etc/apt/preferences"],
}

file { "/etc/apt/preferences" :
  source => "puppet:///modules/base/apt.preferences",
  ensure => present,
}

package { [ augeas-tools ]:
  ensure => latest;
}

include carbon
include graphite
include statsd
include grafana
include elasticsearch
include graphitepoller
include collectd



