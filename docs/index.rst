stream-rpc-express
==================

Call Express app over arbitrary streams (even WebSockets)

To get started, install ``stream-rpc-express`` package via ``npm``::

  % npm install stream-rpc-express

After that you will be able to use ``stream-rpc-express`` library in your code.  The
basic usage example is as follows::

  var createRPC = require('stream-rpc-express'),
      websocket = require('websocket-stream'),
      Server = require('ws').Server,
      through = require('through');

  // define or require your express app
  var express = require('express'),
      app = express();

  server = new Server({port: 3000});
  server.on('connection', function(conn) {
    var socket = websocket(conn),
        rpc = createRPC(app);

    socket
      .pipe(through(function(chunk) { this.push(JSON.parse(chunk)); }))
      .pipe(rpc)
      .pipe(through(function(chunk) { this.push(JSON.stringify(chunk)); }))
      .pipe(socket);
  });

Now in a browser (via browserify), we have ``stream-rpc-express/client`` module
which mimics ``requests`` API::

  var websocket = require('websocket-stream'),
      createClient = require('stream-rpc-express/client')

  var socket = websocket('ws://localhost:3000'),
      client = createClient();

  socket.
    .pipe(through(function(chunk) { this.push(JSON.parse(chunk)); }))
    .pipe(client)
    .pipe(through(function(chunk) { this.push(JSON.stringify(chunk)); }))
    .pipe(socket);

  socket.on('open', function() {
    client.request({
      method: 'GET',
      url: '/someurl'
    }, function(err, result) {

    });
