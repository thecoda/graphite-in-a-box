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
    console.log("Will poll host: [%s] prefix: [%s] on port: [%d]", host.name, host.prefix, host.port);
  	var options = {
      prefix:             host.prefix,
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
    var req = https.get(host, onHttpResponse(host));
    var errFunc = function(host) {
      return function(err) { 
        console.error("When polling host [%s] on port [%d]", host.hostname, host.port);
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

function formatMetric(prefix, obj, m, v, ts) {
  if (prefix == '') return util.format("%s.%s %s %s", obj, m, v, ts);
  else return util.format("%s.%s.%s %s %s", prefix, obj, m, v, ts);
};

function onHttpResponse(host) {
  return function (res) {
    res.setEncoding('utf8');

    res.on('error', logErr);

    var ts = timestamp();

    var key = '';
    var objName = '';

    var buffer = '';

    var processMetric = function(value) {
      if(objName == '') return;
      var str = formatMetric(host.prefix, objName, key, value, ts);
      if(buffer == '') buffer = str;
      else buffer = [buffer, str].join("\n");
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
    res.on('end', function() {
      sendToGraphite(buffer);
    });
  };
};

function sendToGraphite(text) {
  console.log(text);
  var graphite = net.connect({port: 2003, host: '127.0.0.1'}, function() {
    graphite.end(text, 'utf-8');
  }).on('error', logErr);
};
