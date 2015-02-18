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

    app.repositories.deals = new entityRepository app.api, 'deals', { fields: ['industry'] }
    app.repositories.industry = new entityRepository app.api, 'industry', { fields: ['value'] }

    customFields = {}
    customFields[ 'industry' ] = { name: 'Industries' }
    app.repositories.customFields = new entityRepository app.api, 'customFields', { fields: ['name'] }
    app.repositories.customFields._updateEntities customFields

    whenjs.all(
      app.repositories.customFields.getAllEntities().map (repository) ->
        app.repositories[ repository._id ].load()
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

extractNimbleAuthTokenFromRequest = ->
  proxy = require './tools/xmlHttpProxy'
  proxy.onRequestFinish (request) ->
    url = request.responseURL
    tokenMatches = url.match /\/api\/sessions\/([0-9abcdef-]{36})\?/
    if tokenMatches?
      app.options.nimbleToken = tokenMatches[1]
