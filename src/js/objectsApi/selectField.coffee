app = require './../app'

module.exports = class SelectField
  _value: null

  _options: null

  _onValueChange: null

  constructor: (@_value, @_options, @_onValueChange) ->

  _setValue: (newValue) ->
    @_onValueChange? newValue
    @_value = newValue

  createValueEditor: ->
    select = $ "<select></select>"
    for option in @_options
      select.append($("<option value=\"" + option.id + "\">" + option.value + "</option>"))

    select.val @_value or 0
    select.change =>
      @_setValue select.val()

    return select
