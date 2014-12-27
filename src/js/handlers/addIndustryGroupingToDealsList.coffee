app = require '../app'
industryField = require '../industryField'
industryFieldName = 'industry'

module.exports = ->
  groupMatches = location.hash.match /grouped_by=([^&]+)/
  groupingCondition = groupMatches?[1] ? 'none'
  ($ '.dealListByIndustry').hide()
  #TODO: fix or remove commented code
  if groupingCondition is 'industry' #or not (old?.match dealListPattern)
    addGroupingByIndustry groupingCondition

addGroupingByIndustry = (groupingCondition) ->
  selector = '.listHeader .gwt-ListBox'
  app.api.wait.elementRender selector, (groupingListBox) ->
    unless $("""option[value="#{industryFieldName}"]""", groupingListBox).size()
      groupingList = groupingListBox[0]

      $ """<option value="#{industryFieldName}">"""
      .text industryFieldName.replace /^(\w)/, (a, b) -> b.toUpperCase()
      .appendTo groupingList

      if groupingCondition is industryFieldName
        $(groupingList).val(industryFieldName)

    if groupingCondition is industryFieldName
      unless isLoadingInProgress
        isLoadingInProgress = true
        loadDeals (deals) ->
          addIndustryToDeals deals
          renderDealsList deals
          isLoadingInProgress = false

isLoadingInProgress = false

renderDealsList = (deals) ->
  $('.groupGlobalHeader').parent().hide()
  $('.emptyView').hide()

  simpleList = $ '.mainContainer>div>.dealList'
  simpleList.parent().hide()

  container = $ '.dealListByIndustry'
  unless container.size()
    container = $ '<div class="dealListByIndustry">'
    container.insertBefore simpleList.parent()

  groups = {}
  for deal in deals
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

loadDeals = (callback, loadedDeals = [], page = 1) ->
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
      #TODO: use .concat()
      data.resources.forEach (deal) ->
        loadedDeals.push deal

      meta = data.meta
      if meta.has_more
        loadDeals callback, loadedDeals, meta.page + 1
      else
        callback loadedDeals

addIndustryToDeals = (deals) ->
  for deal in deals
    deal.industry = industryField.getValueToDisplay deal.id
