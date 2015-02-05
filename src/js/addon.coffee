app = require './app'
industryField = require './industryField'
industryUI = require './industryUI'
addIndustryGroupingToDealsList = require './handlers/addIndustryGroupingToDealsList'

module.exports = addonEntry =
  start: (_taistApi, entryPoint) ->
    #TODO remove on production
    window.app = app

    extendTaistApi _taistApi
    app.api = _taistApi

    #have to set api.objects to init industryField
    industryField.init()

    setCompanyKey()
    extractNimbleAuthTokenFromRequest()

    industryField.load ->
      setRoutes {
        'app\/deals\/list': -> addIndustryGroupingToDealsList()
        '^app/deals/view': -> industryUI.renderInDealViewer(),
        '^app/deals/edit': -> industryUI.renderInDealEditor(),
        'app/settings/deals': -> industryUI.renderInSettings()
      }

      industryUI.renderInNewDealDialog()

extendTaistApi = (taistApi) ->
  objectsApi = require './objectsApi/objectsApi'
  taistApi.objects = objectsApi
  objectsApi._taistApi = taistApi

setRoutes = (routesByHashes) ->
  for hashRegexp, routeProcessor of routesByHashes
    do (hashRegexp, routeProcessor) =>
      app.api.hash.when hashRegexp, routeProcessor

setCompanyKey = ->
  companySubDomain = location.host.substring 0, (location.host.indexOf '.')
  app.api.companyData.setCompanyKey companySubDomain

extractNimbleAuthTokenFromRequest = ->
  proxy = require './tools/xmlHttpProxy'
  proxy.onRequestFinish (request) ->
    url = request.responseURL
    tokenMatches = url.match /\/api\/sessions\/([0-9abcdef-]{36})\?/
    if tokenMatches?
      app.options.nimbleToken = tokenMatches[1]
