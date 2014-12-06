app = require '../app'

isLoadingInProgress = false

renderDealList = () ->
  $('.groupGlobalHeader').parent().hide()
  $('.emptyView').hide()

  simpleList = $ '.dealList'
  simpleList.parent().hide()

  container = $ '.dealListByIndustry'
  unless container.size()
    container = $ '<div class="dealListByIndustry">'
    container.insertBefore simpleList.parent()

  container.empty().show()
  container.append require '../interface/dealListWithGroups'

  # conatiner.append require '../interface/dealList'

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
        renderDealList()

processDeals = (deals) ->
  deals.resources.forEach (deal) ->
    category = parseInt( deal.id[23], 16 ) % 2

    deal.industry = switch category
      when 1 then 'Food'
      else 'IT'

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
