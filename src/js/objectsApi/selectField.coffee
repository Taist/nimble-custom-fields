app = require './../app'

module.exports = class SelectField
  _value: null

  _options: null

  _onValueChange: null

  constructor: (@_value, @_options, @_onValueChange) ->
    console.log 'SelectField', @_value, @_options

  getDisplayedValue: -> 'ABC' #@_getSelectOptions()[@_value] ? @_options.unsetValueDisplayedText

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
