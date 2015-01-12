app = require './app'

_deals = null

module.exports =
  init: ->
    app.api.objects.registerType "deals", dealsDescription
    _deals = app.api.objects.getType "deals"
  load: (callback) -> _deals.load callback
  _getFieldEditor: (dealId) -> _deals.getFieldValueEditor "industry", (_deals.getEntity dealId)
  getValueToDisplay: (dealId) -> (@_getFieldEditor dealId).getDisplayedValue()
  createValueEditor: (dealId) -> (@_getFieldEditor dealId).createValueEditor()
  createSettingsEditor: -> _deals.createFieldSettingsEditor "industry"

dealsDescription =
  fields:
    industry:
      type: 'select',
      unsetValueDisplayedText: "Not specified"


