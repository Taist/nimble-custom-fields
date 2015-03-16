app = require '../app'
React = require 'react'

customFields = []
selectedFields = {}
notSpecifiedValue = 'Not Specified'

customFieldControlContainer = null

onChangeCustomFieldSelection = (fieldName, isSelected) ->
  selectedFields[fieldName] = isSelected
  app.api.localStorage.set 'selectedCustomFields', selectedFields
  renderCustomFieldsControl()
  addCustomColumnsToOriginalList()

renderCustomFieldsControl = ->
  CustomFieldsSelector = require '../react/dealList/customFieldsSelector'
  React.render (CustomFieldsSelector {
    fields: customFields,
    selected: selectedFields
    onChange: onChangeCustomFieldSelection
  }), customFieldControlContainer

addCustomFieldsControl = ->
  selectedFields = app.api.localStorage.get('selectedCustomFields') or {}
  selector = '.listHeader'
  app.api.wait.elementRender selector, (listHeader) ->
    unless customFieldControlContainer
      customFieldControlContainer = $('<div>')
        .css( { position: 'relative' } )
        .get( 0 )

    $(customFieldControlContainer).appendTo(listHeader)
    renderCustomFieldsControl()

getCurrentGroupingFieldName = () ->
  groupMatches = location.hash.match /grouped_by=([^&]+)/
  currentGroupingFieldName = (groupMatches?[1] ? 'none').replace '+', ' '

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
      if field.type is 'select'
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

  for deal in deals
    customFieldValueId = deal[customField.id]
    value = app.repositories[customField.id].getEntity(customFieldValueId)?.value ? notSpecifiedValue
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

  groupedDeals.sort (a, b) ->
    toStr = (group) -> if group.name is notSpecifiedValue then '' else group.name
    if toStr(a) > toStr(b) then 1 else -1

  return groupedDeals

addCustomColumnsToOriginalList = ->
  addCustomColumnsHeader()
  addCustomColumnsContents()

isFieldVisible = (field) ->
  currentGroupFieldName = getCurrentGroupingFieldName()
  currentGroupFieldName isnt field.name and selectedFields[field.name]

addCustomColumnsHeader = ->
  app.api.wait.elementRender '.DealListView .headerTD.subject', (previousHeader) ->
    (previousHeader.siblings '.taist-custom-header').remove()

    customFields.forEach (field) ->
      if isFieldVisible field
        previousHeader.after $ "<td class=\"headerTD c1 taist-custom-header\">#{field.name}</td>"

addCustomColumnsContents = ->
  app.api.wait.elementRender '.DealListView .dealList .body tr td a.deal_subject', (linkToDealInPreviousCell) ->
    previousCell = linkToDealInPreviousCell.parent()
    (previousCell.siblings '.taist-custom-cell').remove()

    dealUrl = linkToDealInPreviousCell.attr 'href'
    dealIdPrefix = '?id='
    dealIdIndex = (dealUrl.indexOf dealIdPrefix) + dealIdPrefix.length
    dealId = dealUrl.substring dealIdIndex

    dealFields = {}
    deal = app.repositories.deals.getEntity dealId
    dealFields = app.repositories.deals.getFieldsMap( deal ) if deal

    customFields.forEach (field) ->
      if isFieldVisible field
        value = dealFields[field.id]?.value or '-'
        previousCell.after $ """<td class="cell c1 taist-custom-cell" title="#{value}">#{value}</td>"""

loadDealsData = (callback, loadedDeals = [], page = 1) ->
  unless app.options.nimbleToken
    console.log 'There is no Nimble Token'
    setTimeout () ->
      loadDealsData(callback, loadedDeals, page)
    , 1000
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

module.exports = ->
  findCustomDealsList().remove()

  customFields = app.repositories.customFields.getAllEntities()

  addCustomFieldsControl()
  addGroupingByCustomFields()

  loadDealsData (deals) ->
    addCustomFieldToDeals deals

    if currentlyGroupingByCustomField()
      renderCustomDealsList deals

    addCustomColumnsToOriginalList()
