app = require '../app'

customFields = []

module.exports = ->
  findCustomDealsList().remove()

  customFields = app.repositories.customFields.getAllEntities()

  addGroupingByCustomFields()

  loadDealsData (deals) ->
    addCustomFieldToDeals deals

    if currentlyGroupingByCustomField()
      renderCustomDealsList deals

    addCustomColumnsToOriginalList()

getCurrentGroupingFieldName = () ->
  groupMatches = location.hash.match /grouped_by=([^&]+)/
  currentGroupingFieldName = groupMatches?[1] ? 'none'

currentlyGroupingByCustomField = () ->
  currentGroupingFieldName = getCurrentGroupingFieldName()
  customFields.filter(
    (field) -> field.name is currentGroupingFieldName
  ).length > 0

getCurrentGroupingField = () ->
  currentField = null
  currentGroupingFieldName = getCurrentGroupingFieldName()
  customFields.forEach (field) ->
    if field.name is currentGroupingFieldName
      currentField = field
  return currentField

customDealsListClass = 'taist-dealsListWithCustomGrouping'
findCustomDealsList = -> $ '.' + customDealsListClass

addGroupingByCustomFields = () ->
  selector = '.listHeader .gwt-ListBox'
  app.api.wait.elementRender selector, (groupingSelect) ->
    currentGroupingFieldName = getCurrentGroupingFieldName()
    customFields.forEach (field) ->
      fieldName = field.name
      unless $("option[value=\"#{fieldName}\"]", groupingSelect).size()
        capitalizedFieldName = fieldName[0].toUpperCase() + (fieldName.slice 1)
        groupingSelect.append $ """<option value="#{fieldName}">#{capitalizedFieldName}</option>"""

      if currentGroupingFieldName is fieldName
        groupingSelect.val fieldName

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

  customField = getCurrentGroupingField()
  console.log customField

  for deal in deals
    customFieldValueId = deal[customField.id]
    value = app.repositories[customField.id].getEntity(customFieldValueId)?.value ? 'Not specified'
    groups[value] ?= []
    groups[value].push deal

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

addCustomColumnsToOriginalList = ->
  addCustomColumnsHeader()
  addCustomColumnsContents()

addCustomColumnsHeader = ->
  app.api.wait.elementRender '.DealListView .headerTD.subject', (previousHeader) ->
    if not currentlyGroupingByCustomField()
      (previousHeader.siblings '.taist-custom-header').remove()
      customFields.forEach (field) ->
        previousHeader.after $ "<td class=\"headerTD c1 taist-custom-header\">#{field.name}</td>"

addCustomColumnsContents = ->
  app.api.wait.elementRender '.DealListView .dealList .body tr td a.deal_subject', (linkToDealInPreviousCell) ->
    if not currentlyGroupingByCustomField()
      previousCell = linkToDealInPreviousCell.parent()
      (previousCell.siblings '.taist-custom-cell').remove()

      dealUrl = linkToDealInPreviousCell.attr 'href'
      dealIdPrefix = '?id='
      dealIdIndex = (dealUrl.indexOf dealIdPrefix) + dealIdPrefix.length
      dealId = dealUrl.substring dealIdIndex

      customFields.forEach (field) ->
        customFieldValueId = app.repositories.deals.getEntity(dealId)?[field.id]
        value = app.repositories[field.id].getEntity(customFieldValueId)?.value ? 'Not specified'
        previousCell.after $ """<td class="cell c1 taist-custom-cell">#{value}</td>"""

loadDealsData = (callback, loadedDeals = [], page = 1) ->
  unless app.options.nimbleToken
    console.log 'There is no Nimble Token'
    setTimeout () ->
      loadDealsData(callback, loadedDeals, page)
    , 200
    return

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
    $.extend deal, app.repositories.deals.getEntity deal.id
