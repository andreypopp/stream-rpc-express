rpc = require 'stream-rpc'
querystring = require 'querystring'

bodyMethods = ['POST', 'PUT', 'PATCH']

module.exports = ->
  client = rpc()
  client.request = (options, callback) ->
    request =
      url: options.uri or options.url
      method: options.method or 'GET'
      headers: options.headers or {}
      body: ''

    if options.qs
      request.url = "#{request.url}?#{querystring.stringify(options.qs)}"

    if bodyMethods.some((m) -> m == options.method)
      request.body = options.json
      request.headers['Content-type'] = 'application/json'

    client.call(request, callback)

  client
