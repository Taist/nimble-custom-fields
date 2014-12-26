app = require '../app'
industryField = require '../industryField'

isLoadingInProgress = false

renderDealList = ->
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
    industry = deal.industry
    groups[industry] ?= []
    groups[industry].push deal

  groupedDeals = []
  for name, group of groups
    amount =
      full: 0
      weighted: 0

    group.reduce (amount, deal) ->
      amount.full += deal.amount
      amount.weighted += deal.amount * deal.probability / 100
      return amount
    , amount

    groupedDeals.push {name, group, amount}

  container.show()

  React = require 'react'
  GrouppedDealList = require '../react/grouppedDealList/grouppedDealList'
  React.render (GrouppedDealList {deals: groupedDeals}), container[0]

loadDeals = (page = 1) ->
  $.ajax
    url: '/api/deals'
    dataType: "json"
    headers:
      Authorization: """Nimble token="#{app.options.nimbleToken}\""""
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
    deal.industry = industryField.getValueToDisplay deal.id
    app.data.deals[deal.id] = deal

module.exports = (groupingCondition) ->
  selector = '.listHeader .gwt-ListBox'

  customFieldName = 'industry'

  app.api.wait.elementRender selector, (element) ->
    unless $("""option[value="#{customFieldName}"]""", element).size()
      groupingList = element[0]

      $ """<option value="#{customFieldName}">"""
      .text customFieldName.replace /^(\w)/, (a, b) -> b.toUpperCase()
      .appendTo groupingList

      if groupingCondition is customFieldName
        $(groupingList).val(customFieldName)

    if groupingCondition is customFieldName
      unless isLoadingInProgress
        isLoadingInProgress = true
        loadDeals()
