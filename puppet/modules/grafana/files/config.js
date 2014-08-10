///// @scratch /configuration/config.js/1
 // == Configuration
 // config.js is where you will find the core Grafana configuration. This file contains parameter that
 // must be set before Grafana is run for the first time.
 ///
define(['settings'],
function (Settings) {
  

  return new Settings({

    datasources: {
      graphite: {
        type: 'graphite',
        url: "http://"+window.location.hostname+":8080",
        default: true,
      },
      grafana: {
        type: 'influxdb',
        url: "http://"+window.location.hostname+":8086/db/grafana",
        username: 'root',
        password: 'root',
        grafanaDB: true
      },
      influxdb: {
        type: 'influxdb',
        url: "http://"+window.location.hostname+":8086/db/metrics",
        username: 'root',
        password: 'root',
      },
    },

    /* Global configuration options
    * ========================================================
    */

    // specify the limit for dashboard search results
    search: {
      max_results: 20
    },

    // default start dashboard
    default_route: '/dashboard/file/default.json',

    // set to false to disable unsaved changes warning
    unsaved_changes_warning: true,

    // set the default timespan for the playlist feature
    // Example: "1m", "1h"
    playlist_timespan: "1m",

    // If you want to specify password before saving, please specify it bellow
    // The purpose of this password is not security, but to stop some users from accidentally changing dashboards
    admin: {
      password: ''
    },

    // Add your own custom pannels
    plugins: {
      panels: []
    }

  });
});
