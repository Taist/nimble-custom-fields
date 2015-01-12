module.exports = class PersistedValue
  _taistApi: null
  _name: null
  _value: null
  constructor: (@_taistApi, @_name) ->

  load: (callback) ->
    @_taistApi.companyData.get @_name, (err, value) =>
      @_value = value
      callback?()

  get: -> @_value

  set: (newValue, callback)

