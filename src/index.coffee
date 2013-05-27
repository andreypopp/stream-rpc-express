###

  Call Connect/Express apps over arbitrary streams (even WebSocket)

###

express = require 'express'
{EventEmitter} = require 'events'
rpc = require 'stream-rpc'

class Request

  constructor: (message) ->
    this.message = message

    this.method = message.method or 'GET'
    this.url = message.url or '/'
    this.headers = message.headers or {}
    this.body = message.body or {}

class Response extends EventEmitter

  constructor: ->
    this.headers = {}
    this.statusCode = 200

  send: (statusCode, body) ->
    if not body
      body = statusCode
      statusCode = 200
    this.statusCode = statusCode
    this.end(body)

  end: (data) ->
    this.body = data if data
    if not this.headers['Content-Type']
      this.headers['Connect-Type'] = 'application/json'
    this.emit 'end'

  getHeader: (name) ->
    this.headers[name]

  setHeader: (name, value) ->
    this.headers[name] = value

module.exports = (app) ->
  outerApp = express()

  outerApp.request = {__proto__: Request.prototype}
  outerApp.response = {__proto__: Response.prototype}

  outerApp.use app

  stream = rpc
    handle: (message, done) ->
      req = new Request(message)
      res = new Response()

      res.on 'end', ->
        done null,
          statusCode: res.statusCode
          body: res.body
          headers: res.headers

      try
        app.handle(req, res)
      catch err
        done(err)

  stream
