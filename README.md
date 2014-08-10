graphite-in-a-box
=================

This is a fully armed and operational graphite installation with all the trimmings in Vagrant form.

Where possible I've used the latest version of all components and harvested best practices for Graphite whereve I found them online. My main source of inspiration was a series of posts starting at: <https://www.digitalocean.com/community/tutorials/how-to-install-and-use-graphite-on-an-ubuntu-14-04-server>

This setup (at the time of writing) consists of:

- Ubuntu 14.04 (Trusty Tahir) LTS
- Graphite (carbon + graphite-web) v0.9.12
- Postgres (for the Graphite DB, instead of the default SQLite)
- Memcached for carbon caching
- The [Grafana](http://grafana.org/) front-end, version 1.7.0-rc1
- Elasticsearch (for saving grafana dashboards)
- openjdk-7 (required for elasticsearch)
- statsd 0.6.0, configured to NOT use the legacy namespace
- nodejs
- A reasonable schema and aggregation configuration, specifically customised for codahale-metrics and statsd
- My own graphite-poller application, which will poll JSON endpoints in the format used by [codahale-metrics](http://metrics.codahale.com/) and feed the information to graphite.

Once installed, just head over to <http://localhost:8080/grafana/> to start playing.

Todo
----

- pre-configure some nicer grafana defaults (e.g. a local collectd graph)
- increase open-files limit, as per <http://docs.basho.com/riak/latest/ops/tuning/open-files-limit/>


Ideas that need more research
-----------------------------

- could graphite-poller to send to statsd instead of directly to graphite? (example at <https://github.com/etsy/statsd>)
- Better still... Why not push directly to influxDB, and bypass graphite entirely?
- While we're at it, configure statsd to push to influxdb instead of graphite
- How easy would it be to make graphite/influxdb configurable as a gobal option?


