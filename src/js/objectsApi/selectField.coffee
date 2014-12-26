app = require './../app'

module.exports = class SelectField
  _name: null

  _entity: null

  _options: null

  _settings: null

  constructor: (@_entity, @_name, @_options, @_settings) ->

  _getSelectOptions: ->
    orderedOptionNames = (@_settings.selectOptions ? "").split '\n'
    selectOptions = {}
    for option, index in orderedOptionNames
      selectOptions[index] = option

    return selectOptions

  getDisplayedValue: -> @_getSelectOptions()[@_getRawValue()] ? @_options.unsetValueDisplayedText

  _getRawValue: -> @_entity.getFieldValue @_name

  _setValue: (newValue) ->
    @_entity.setFieldValue @_name, newValue
    @_entity.save ->

  createValueEditor: ->
    select = $ "<select></select>"
    defaultOption = $ "<option >" + @_options.unsetValueDisplayedText + "</option>"
    select.append defaultOption

    for optionId, optionName of @_getSelectOptions()
      select.append($("<option value=\"" + optionId + "\">" + optionName + "</option>"))

      select.val @_getRawValue()
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

