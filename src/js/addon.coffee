app = require './app'

addonEntry =
  start: (_taistApi, entryPoint) ->
    #TODO remove in production
    window.app = app

    app.api = _taistApi

    proxy = require './tools/xmlHttpProxy'
    proxy.registerHandler (request) ->
      url = request.responseURL
      matches = url.match /\/api\/sessions\/([0-9abcdef-]{36})\?/
      if matches
        app.options.nimbleToken = matches[1]

    onChangeHash = require './handlers/onChangeHash'
    _taistApi.hash.onChange onChangeHash

module.exports = addonEntry
