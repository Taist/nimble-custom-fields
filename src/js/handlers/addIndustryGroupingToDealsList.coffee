app = require '../app'
industryField = require '../industryField'
customFieldName = 'industry'

module.exports = ->
  findCustomDealsList().remove()

  addGroupingByCustomField()

  loadDealsData (deals) ->
    addCustomFieldToDeals deals

    if currentlyGroupingByCustomField()
      renderCustomDealsList deals

    addCustomColumnToOriginalList()

currentlyGroupingByCustomField = ->
  groupMatches = location.hash.match /grouped_by=([^&]+)/
  currentGroupingField = groupMatches?[1] ? 'none'
  return currentGroupingField is customFieldName

customDealsListClass = 'taist-dealsListWithCustomGrouping'
findCustomDealsList = -> $ '.' + customDealsListClass

addGroupingByCustomField = ->
  selector = '.listHeader .gwt-ListBox'
  app.api.wait.elementRender selector, (groupingSelect) ->
    unless $("""option[value="#{customFieldName}"]""", groupingSelect).size()
      capitalizedFieldName = customFieldName[0].toUpperCase() + (customFieldName.slice 1)
      groupingSelect.append $ """<option value="#{customFieldName}">#{capitalizedFieldName}</option>"""

    if currentlyGroupingByCustomField()
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

addCustomColumnToOriginalList = ->
    addCustomColumnHeader()
    addCustomColumnContents()

addCustomColumnHeader = ->
  app.api.wait.elementRender '.DealListView .headerTD.subject', (previousHeader) ->
    if not currentlyGroupingByCustomField()
      (previousHeader.siblings '.taist-custom-header').remove()
      previousHeader.after $ """<td class="headerTD c3 taist-custom-header">Industry</td>"""

addCustomColumnContents = ->
  app.api.wait.elementRender '.DealListView .dealList .body tr td a.deal_subject', (linkToDealInPreviousCell) ->
    if not currentlyGroupingByCustomField()
      previousCell = linkToDealInPreviousCell.parent()
      console.log {previousCell}

      dealUrl = linkToDealInPreviousCell.attr 'href'
      dealIdPrefix = '?id='
      dealIdIndex = (dealUrl.indexOf dealIdPrefix) + dealIdPrefix.length
      dealId = dealUrl.substring dealIdIndex
      industry = industryField.getIndustryName dealId

      (previousCell.siblings '.taist-custom-cell').remove()
      previousCell.after $ """<td class="cell c3 taist-custom-cell">#{industry}</td>"""


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
