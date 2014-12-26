app = require './app'

app.api.objects.registerType "deals", {
  fields:
    industry:
      type: 'select',
      unsetValueDisplayedText: "Not specified"
}

deals = app.api.objects.getType("deals")

module.exports =
  load: (callback) -> deals.load callback
  _getFieldEditor: (dealId) -> deals.getFieldValueEditor "industry", (deals.getEntity dealId)
  getValueToDisplay: (dealId) -> (@_getFieldEditor dealId).getDisplayedValue()
  createValueEditor: (dealId) -> (@_getFieldEditor dealId).createValueEditor()
  createSettingsEditor: -> deals.createFieldSettingsEditor "industry"



