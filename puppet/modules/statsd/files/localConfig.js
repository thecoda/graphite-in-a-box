{
  ignore_backends: ['/usr/share/statsd/backends/graphite', '/usr/share/statsd/backends/statsd-influxdb-backend']
, ignore_influxdb: { database: 'metrics', username: 'root', password: 'root' }
, graphitePort: 2003
, graphiteHost: "localhost"
, port: 8125
, graphite: {
    legacyNamespace: false
  }
}
