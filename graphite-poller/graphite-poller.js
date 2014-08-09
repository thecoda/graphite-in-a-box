'use strict';
 
//process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
 
var fs = require('fs');
var net = require('net');
var util = require('util');
var https = require('https');
var createSource = require('stream-json');

var config = JSON.parse( fs.readFileSync('config.js')  );

function mkHosts() {
  var arr = [];
  var numHosts = config.hosts.length;
  for (var i = 0; i < numHosts; i++) {
  	var host = config.hosts[i];
    console.log("Will poll host: [%s] on port: [%d]", host.name, host.port);
  	var options = {
      hostname:           host.name,
      port:               host.port,
      path:               '/metrics',
      method:             'GET',
      rejectUnauthorized: false
    };
  	arr.push(options);    
  }
  return arr;
}

var hosts = mkHosts();

function logErr(e) { console.error(e); };

poll();
setInterval(poll, 1000 * config.poll_interval);

function poll() {
  var numHosts = hosts.length;
  for (var i = 0; i < numHosts; i++) {
  	var host = hosts[i];
  	console.log("polling host: [%s] on port: [%d]", host.hostname, host.port);
    var req = https.get(host, onHttpResponse);
    var errFunc = function(host) {
      return function(err) { 
        var errMsg = util.format("When polling host: [%s] on port: [%d]", host.hostname, host.port);
        console.error(errMsg);
        console.error(err);
      };
    };
    req.on('error', errFunc(host));
  }
};

function timestamp() {
  var d = new Date();
  return Math.floor(d.valueOf() / 1000);
};

function formatMetric(obj, m, v, ts) { return util.format("%s.%s %s %s", obj, m, v, ts); };

function onHttpResponse(res) {
  res.on('error', logErr);

  var ts = timestamp();

  var key = '';
  var objName = '';

  var processMetric = function(value) {
    if(objName == '') return;
    var str = formatMetric(objName, key, value, ts);
    sendToGraphite(str.concat('\n'));
  };

  var jsonSrc =
    createSource()
      .on("keyValue",    function(value){ key     = value; })
      .on("startObject", function()     { objName = key;   })
      .on("endObject",   function()     { objName = '';    })
      .on("stringValue", processMetric)
      .on("numberValue", processMetric)
      .on('error',       logErr);


  res.pipe(jsonSrc.input);
};

function sendToGraphite(line) {
  var graphite = net.connect({port: 2003, host: '127.0.0.1'}, function() {
    graphite.write(line);
    graphite.end();
  }).on('error', logErr);
};
