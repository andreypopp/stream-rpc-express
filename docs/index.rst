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

Now in a browser (via browserify)::

  var websocket = require('websocket-stream'),
      createRPC = require('stream-rpc');

  var socket = websocket('ws://localhost:3000'),
      rpc = createRPC();

  socket.
    .pipe(through(function(chunk) { this.push(JSON.parse(chunk)); }))
    .pipe(rpc)
    .pipe(through(function(chunk) { this.push(JSON.stringify(chunk)); }))
    .pipe(socket);

  socket.on('open', function() {
    rpc.call({
      method: 'GET',
      url: '/someurl'
    }, function(err, result) {

    });
