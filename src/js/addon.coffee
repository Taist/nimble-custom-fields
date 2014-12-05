api = require './globals/api'

addonEntry =
  start: (_taistApi, entryPoint) ->
    $.extend api, _taistApi

    onChangeHash = require './handlers/onChangeHash'
    _taistApi.hash.onChange onChangeHash

module.exports = addonEntry
