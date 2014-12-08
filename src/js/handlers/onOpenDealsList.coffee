app = require '../app'

isLoadingInProgress = false

renderDealList = () ->
  $('.groupGlobalHeader').parent().hide()
  $('.emptyView').hide()

  simpleList = $ '.mainContainer>div>.dealList'
  simpleList.parent().hide()

  container = $ '.dealListByIndustry'
  unless container.size()
    container = $ '<div class="dealListByIndustry">'
    container.insertBefore simpleList.parent()

  groups = {}
  for id, deal of app.data.deals
    industry = deal.industry || 'Unknown'
    unless groups[industry]
      groups[industry] = []
    groups[industry].push deal

  grouppedDeals = []
  for name, group of groups
    amount =
      full: 0
      weighted: 0

    group.reduce (amount, deal) ->
      amount.full += deal.amount
      amount.weighted += deal.amount * deal.probability / 100
      return amount
    , amount

    grouppedDeals.push { name, group, amount }

  container.show()

  React = require 'react'
  GrouppedDealList = require('../react/grouppedDealList')
  React.render ( GrouppedDealList { deals: grouppedDeals } ), container[0]

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

    #TODO Remove fake data
    category = parseInt( deal.id[23], 16 ) % 4
    deal.industry = switch category
      when 1 then 'Food'
      when 2 then 'Toys'
      when 3 then 'IT'

    app.data.deals[deal.id] = deal

module.exports = (groupingCondition) ->
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
