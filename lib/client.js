// Generated by CoffeeScript 1.6.2
var bodyMethods, querystring, rpc;

rpc = require('stream-rpc');

querystring = require('querystring');

bodyMethods = ['POST', 'PUT', 'PATCH'];

module.exports = function() {
  var client;

  client = rpc();
  client.request = function(options, callback) {
    var request;

    request = {
      url: options.uri || options.url,
      method: options.method,
      headers: options.headers,
      body: ''
    };
    if (options.qs) {
      request.url = "" + request.url + "?" + (querystring.stringify(options.qs));
    }
    if (bodyMethods.some(function(m) {
      return m === options.method;
    })) {
      request.body = options.json;
      request.headers['Content-type'] = 'application/json';
    }
    return client.call(request, callback);
  };
  return client;
};