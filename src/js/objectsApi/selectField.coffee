app = require './../app'

module.exports =
  class SelectField
    _fieldName: null
    _unsetOptionText: null
    _options: null
    _data: null

    constructor: (@_fieldName, @_unsetOptionText) ->

    init: ->
      #TODO: load from db here
      @_options =
        0: 'Toys'
        1: 'IT'
        2: 'Retail'
        3: 'Finance'

      @_data = {}

    getValue: (recordId) ->
      @_data[recordId]

    getDisplayedValue: (recordId) ->
      @_options[@getValue recordId]

    setValue: (recordId, newValue) ->
      @_data[recordId] = newValue
      #TODO: persist here

    createEditUI: (recordId) ->
      select = $ "<select></select>"
      defaultOption = $ """<option >#{@_unsetOptionText}</option>"""

      select.append defaultOption
      for optionId, optionName of @_options
        select.append $ """<option value="#{optionId}">#{optionName}</option>"""

      select.val (@getValue recordId)
      select.change =>
        #saving value immediately without user confirmation
        @setValue recordId, select.val()

