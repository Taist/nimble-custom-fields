app = require './app'
objectsApi = require './objectsApi/objectsApi'

listenForDealsListDisplay = require './handlers/listenForDealsListDisplay'

addonEntry =
  start: (_taistApi, entryPoint) ->
    _taistApi.objects = objectsApi
    objectsApi._taistApi = _taistApi
    app.api = _taistApi

    #have to set api.objects before requiring industryField
    industryField = require './industryField'
    industryUI = require './industryUI'

    setCompanyKey()
    extractNimbleAuthTokenFromRequest()

    industryField.load ->
      listenForDealsListDisplay()
      industryUI.waitToRender()

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

module.exports = addonEntry

