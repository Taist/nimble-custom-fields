app = require '../app'
industryField = require '../industryField'
customFieldName = 'industry'

module.exports = ->
  findCustomDealsList().remove()

  addGroupingByCustomField()

  if getCurrentGroupingField() is customFieldName
    loadDealsData (deals) ->
      addCustomFieldToDeals deals
      renderCustomDealsList deals

getCurrentGroupingField = ->
  groupMatches = location.hash.match /grouped_by=([^&]+)/
  return groupMatches?[1] ? 'none'

customDealsListClass = 'taist-dealsListWithCustomGrouping'
findCustomDealsList = -> $ '.' + customDealsListClass

addGroupingByCustomField = ->
  selector = '.listHeader .gwt-ListBox'
  app.api.wait.elementRender selector, (groupingSelect) ->
    unless $("""option[value="#{customFieldName}"]""", groupingSelect).size()
      capitalizedFieldName = customFieldName[0] + (customFieldName.slice 1)
      groupingSelect.append $ """<option value="#{customFieldName}">#{capitalizedFieldName}</option>"""

    if getCurrentGroupingField() is customFieldName
      groupingSelect.val customFieldName

renderCustomDealsList = (deals) ->
  customDealsList = replaceOriginalListWithCustom()

  customDealsList.show()
  groupedDeals = groupDealsByCustomField deals

  React = require 'react'
  GroupedDealList = require '../react/groupedDealList/groupedDealList'
  React.render (GroupedDealList {deals: groupedDeals}), customDealsList[0]

replaceOriginalListWithCustom = ->
  $('.groupGlobalHeader').parent().hide()
  $('.emptyView').hide()

  originalDealsList = ($ '.mainContainer>div>.dealList').parent()
  originalDealsList.hide()

  customDealsList = $ """<div class="#{customDealsListClass}">"""
  customDealsList.insertBefore originalDealsList

  return customDealsList

groupDealsByCustomField = (deals) ->
  groups = {}
  for deal in deals
    customFieldValue = deal[customFieldName]
    groups[customFieldValue] ?= []
    groups[customFieldValue].push deal

  groupedDeals = []
  for name, group of groups
    amount =
      full: 0
      weighted: 0

    for deal in group
      amount.full += deal.amount
      amount.weighted += deal.amount * deal.probability / 100

    groupedDeals.push {name, group, amount}

  return groupedDeals

loadDealsData = (callback, loadedDeals = [], page = 1) ->
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
        loadDealsData callback, loadedDeals, meta.page + 1
      else
        callback loadedDeals

addCustomFieldToDeals = (deals) ->
  for deal in deals
    deal.industry = industryField.getIndustryName deal.id
