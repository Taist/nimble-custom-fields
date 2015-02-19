app = require './app'

_deals = null
_industries = null

industryField = "industry"
industryNameField = "value"
notSpecifiedCaption = "Not specified"

module.exports =
  init: () ->
    _deals = app.repositories.deals
    _industries = app.repositories.industry

  getIndustryName: (dealId) ->
    deal = _deals.getOrCreateEntity dealId
    industryId = deal.industry
    if industryId?
      industryName = (_industries.getEntity industryId)?.value

    industryName ?= notSpecifiedCaption
