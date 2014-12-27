app = require './app'
objectsApi = require './objectsApi/objectsApi'
industryUI = null
addIndustryGroupingToDealsList = null

module.exports = addonEntry =
  start: (_taistApi, entryPoint) ->
    _taistApi.objects = objectsApi
    objectsApi._taistApi = _taistApi
    app.api = _taistApi

    #have to set api.objects before requiring industryField
    industryField = require './industryField'
    industryUI = require './industryUI'
    addIndustryGroupingToDealsList = require './handlers/addIndustryGroupingToDealsList'

    setCompanyKey()
    extractNimbleAuthTokenFromRequest()

    industryField.load ->
      setRoutes()

setRoutes = ->
  routesByHashes =
    'app\/deals\/list': -> addIndustryGroupingToDealsList()
    '^app/deals/view': -> industryUI.renderInDealViewer(),
    '^app/deals/edit': -> industryUI.renderInDealEditor(),
    'app/settings/deals': -> industryUI.renderInSettings()

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
