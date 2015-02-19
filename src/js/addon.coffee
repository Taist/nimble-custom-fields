app = require './app'
entityRepository = require './objectsApi/entityRepository'

industryField = require './industryField'
industryUI = require './industryUI'

addIndustryGroupingToDealsList = require './handlers/addIndustryGroupingToDealsList'

whenjs = require 'when'

getNewEntityId = ->
  new Date().getTime() + Math.random()

module.exports = addonEntry =
  start: (_taistApi) ->
    #TODO remove on production
    window.app = app
    app.api = _taistApi

    extractNimbleAuthTokenFromRequest()

    waitingForNewDealRequest()

    app.repositories.deals = new entityRepository app.api, 'deals'

    customFields = {}
    customFields[ 'industry' ] = { id: 'industry', name: 'Industries' }
    customFields[ '1424347059189.5615' ] = { id: '1424347059189.5615', name: 'CustomField' }
    app.repositories.customFields = new entityRepository app.api, 'customFields'
    app.repositories.customFields._updateEntities customFields

    whenjs.all(
      app.repositories.customFields.getAllEntities().map (repository) ->
        id = repository.id
        app.repositories[id] = new entityRepository(app.api, id)
        app.repositories[id].load()
    )
    .then () ->
      app.repositories.deals.load()
    .then () ->
      industryField.init()
      setRoutes()
      industryUI.renderInNewDealDialog()

routesByHashes =
  'app\/deals\/list': -> addIndustryGroupingToDealsList()
  '^app/deals/view': -> industryUI.renderInDealViewer()
  '^app/deals/edit': -> industryUI.renderInDealEditor()
  'app/settings/deals': -> industryUI.renderInSettings()

setRoutes = ->
  for hashRegexp, routeProcessor of routesByHashes
    do (hashRegexp, routeProcessor) =>
      app.api.hash.when hashRegexp, routeProcessor

proxy = require './tools/xmlHttpProxy'

extractNimbleAuthTokenFromRequest = ->
  proxy.onRequestFinish (request) ->
    url = request.responseURL
    tokenMatches = url.match /\/api\/sessions\/([0-9abcdef-]{36})\?/
    if tokenMatches?
      app.options.nimbleToken = tokenMatches[1]

waitingForNewDealRequest = ->
  proxy.onRequestFinish (request) ->
    url = request.responseURL
    if url.match /\/api\/deals\?/
      dealId = JSON.parse(request.responseText)?.deal?.id
      industryUI.saveCustomFieldsForNewDeal dealId
