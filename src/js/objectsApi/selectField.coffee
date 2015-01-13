app = require './../app'

module.exports = class SelectField
  _value: null

  _options: null

  _settings: null

  _onValueChange: null

  constructor: (@_value, @_options, @_settings, @_onValueChange) ->

  _getSelectOptions: ->
    orderedOptionNames = (@_settings.selectOptions ? "").split '\n'
    selectOptions = {}
    for option, index in orderedOptionNames
      selectOptions[index] = option

    return selectOptions

  getDisplayedValue: -> @_getSelectOptions()[@_value] ? @_options.unsetValueDisplayedText

  _setValue: (newValue) ->
    @_onValueChange? newValue
    @_value = newValue

  createValueEditor: ->
    select = $ "<select></select>"
    defaultOption = $ "<option >" + @_options.unsetValueDisplayedText + "</option>"
    select.append defaultOption

    for optionId, optionName of @_getSelectOptions()
      select.append($("<option value=\"" + optionId + "\">" + optionName + "</option>"))

      select.val @_value
      select.change =>
        @_setValue select.val()

    return select

  @createSettingsEditor: (currentSettings, settingsUpdateCallback) ->
    textArea = $ "<textarea></textarea>"
    optionLines = currentSettings.selectOptions
    textArea.val optionLines
    textArea.change =>
      currentSettings.selectOptions = textArea.val()
      settingsUpdateCallback currentSettings

    return textArea

