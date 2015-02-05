app = require './app'

_deals = null

module.exports =
  init: ->
    app.api.objects.registerType "deals", dealsDescription
    _deals = app.api.objects.getTypeRepository "deals"

  load: (callback) -> _deals.load callback
  _getFieldEditor: (dealId, customOnValueChange) -> _deals.getFieldValueEditor "industry", (_deals.getEntity dealId), customOnValueChange

  #TODO: change to:
#  createEditForm: (dealId) ->
#    app.api.objects.createEntityEditForm (_deals.getEntity dealId), {fields: ["industry"], saveButton: saveButtonSelector}
  createValueEditor: (dealId) -> (@_getFieldEditor dealId).createValueEditor()

  #TODO: change to:
#  getIndustryName: (dealId) ->
#    (_deals.getEntity dealId).getField("industry").getField("name")
  getIndustryName: (dealId) -> (@_getFieldEditor dealId).getDisplayedValue()

  #TODO: change accordingly to upper ones
  createValueEditorForNewDeal: (onValueChange) ->
    fieldOptions = _deals._schema.fields["industry"]
    fieldUIConstructor = app.api.objects.fieldEditors[fieldOptions.type]
    fieldUI = new fieldUIConstructor null, fieldOptions, (_deals._getFieldSettings "industry"), (newValue) -> onValueChange newValue

    window.fieldUI = fieldUI

    return fieldUI.createValueEditor()

  setIndustryInDeal: (dealId, industryId, callback) ->
    deal = _deals.getEntity dealId
    deal.setFieldValue "industry", industryId
    deal.save callback

dealsDescription =
  fields:
    industry:
      type: 'select',
      unsetValueDisplayedText: "Not specified"
