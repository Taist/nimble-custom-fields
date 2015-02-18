app = require './app'
selectField = require './objectsApi/selectField'

_deals = null
_industries = null

industryField = "industry"
industryNameField = "value"
notSpecifiedCaption = "Not specified"

module.exports =
  init: () ->
    _deals = app.repositories.deals
    _industries = app.repositories.industry

  createValueEditor: (dealId) ->
    entity = _deals.getOrCreateEntity dealId
    return @_createIndustryEditor (entity.getFieldValue industryField), (newValue) ->
      entity.setFieldValue industryField, newValue
      entity.save ->

  getIndustryName: (dealId) ->
    deal = _deals.getOrCreateEntity dealId
    industryId = deal.getFieldValue industryField
    if industryId?
      industryName = (_industries.getEntity industryId)?.getFieldValue industryNameField

    industryName ?= notSpecifiedCaption

  _createIndustryEditor: (currentIndustryId, onValueChange) ->
    industryListValues = ({id: industry._id, value: industry._data.value} for industry in @_getOrderedIndustriesList())
    industryListValues.unshift { id: 0, value: 'Not specified' }
    fieldUI = new selectField currentIndustryId, industryListValues, onValueChange
    return fieldUI.createValueEditor()

  _getOrderedIndustriesList: ->
    industriesList = _industries.getAllEntities()
    industriesList.sort (i1, i2) ->
      name1 = i1.getFieldValue industryNameField
      name2 = i2.getFieldValue industryNameField
      if name1 > name2
        return 1
      else if name1 < name2
        return -1
      else
        return 0

    return industriesList

  createValueEditorForNewDeal: (onValueChange) ->
    @_createIndustryEditor null, onValueChange

  setIndustryInDeal: (dealId, industryId, callback) ->
    deal = _deals.getOrCreateEntity dealId
    deal.setFieldValue industryField, industryId
    deal.save callback
