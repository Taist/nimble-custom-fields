app = require '../app'

isLoadingInProgress = false

loadDeals = (page = 1) ->
  $.ajax
    url: '/api/deals'
    dataType: "json"
    headers:
      Authorization: "Nimble token=\"#{app.options.nimbleToken}\""
    data:
      sort_by: 'age'
      dir: 'asc'
      page: page
      per_page: app.options.dealsPerPage
    success: (data) ->
      processDeals data
      meta = data.meta
      if meta.has_more
        loadDeals meta.page + 1
      else
        isLoadingInProgress = false

processDeals = (deals) ->
  deals.resources.forEach (deal) ->
    app.api.log deal
    app.data.deals[deal.id] = deal

module.exports = (groupingCondition) ->
  app.api.log 'Hello world', groupingCondition

  selector = '.listHeader .gwt-ListBox'
  app.api.wait.elementRender selector, (element) ->
    unless $('option[value="industry"]', element).size()
      groupingList = element[0]

      $ '<option value="industry">'
        .text 'Industry'
        .appendTo groupingList

      if groupingCondition is 'industry'
        $(groupingList).val('industry')

      groupingList.addEventListener 'change', ->
        app.api.log this.value

    if groupingCondition is 'industry'
      unless isLoadingInProgress
        isLoadingInProgress = true
        loadDeals()
