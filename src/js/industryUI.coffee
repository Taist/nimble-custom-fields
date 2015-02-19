app = require './app'
industryField = require './industryField'

React = require 'react'

module.exports =
  _industryForNewDeal: null
  renderInNewDealDialog: ->
    app.api.wait.elementRender '.DealCreateForm tbody', (dealCreateFormTable) =>
      industrySelectUI = $ @_industrySelectInDealCreationTemplate
      industryEditor = industryField.createValueEditorForNewDeal (selectedIndustry) =>
        @_industryForNewDeal = selectedIndustry
        app.api.log "industry for new deal: ", @_industryForNewDeal

      (industrySelectUI.find '.taist-selectWrapper').append industryEditor

      previousRow = (dealCreateFormTable.find '.fieldCell.stage').parent()

      console.log "rendering: ", industrySelectUI, dealCreateFormTable
      previousRow.after industrySelectUI

  _getDealIdFromUrl: -> location.hash.substring((location.hash.indexOf '?id=') + 4)

  _getAddonContainer: (parent) ->
    container = $('.taistContainer', parent)
    unless container.length
      container = $('<div class="taistContainer">').appendTo parent
    container[0]

  _getCustomFieldsDicts: ->
    app.repositories.customFields.getAllEntities().map (repository) =>
      id: repository.id
      name: repository.name
      entities: app.repositories[repository.id].getDictionary()

  _getCustomFieldsValues: (deal) ->
    unless deal
      deal = app.repositories.deals.getEntity @_getDealIdFromUrl()

    app.repositories.customFields.getAllEntities().map (repository) =>
      id = repository.id
      customFieldEntity = app.repositories[id]?.getEntity(deal[id])
      return {
        id: customFieldEntity?.id or 0
        name: repository.name
        value: customFieldEntity?.value or 'Not specified'
      }

  renderInDealEditor: ->
    app.api.wait.elementRender '.dealInfoTab .leftColumn', (parent) =>
      container = @_getAddonContainer parent

      dicts = @_getCustomFieldsDicts()

      deal = app.repositories.deals.getEntity @_getDealIdFromUrl()
      fields = @_getCustomFieldsValues deal

      onChange = (dictId, optionId) ->
        deal[dictId] = optionId
        app.repositories.deals._saveEntity deal, ->
          console.log 'I belive it is successfuly saved', dictId, optionId

      CustomFieldsInDealEditor = require './react/customFields/CustomFieldsInDealEditor'
      React.render ( CustomFieldsInDealEditor { dicts, fields, onChange } ), container

  renderInDealViewer: ->
    app.api.wait.elementRender '.DealView .generalInfo', (parent) =>
      container = @_getAddonContainer parent

      fields = @_getCustomFieldsValues()

      CustomFieldsViewer = require './react/customFields/CustomFieldsViewer'
      React.render ( CustomFieldsViewer { fields } ), container

  renderInSettings: ->
    app.api.wait.elementRender '.SettingsDealsView', (parent) =>

      container = @_getAddonContainer parent
      CustomFieldsEditor = require './react/customFields/CustomFieldsEditor'

      onUpdateDictionary = (entities) ->
        #The function is called with dict as a context because of React
        repoEntities = {}
        entities.forEach (entity) ->
          repoEntities[entity.id] = entity
        app.repositories[@id].save repoEntities, ->

        dicts.forEach (dict) =>
          if dict.id is @id
            dict.entities = entities
        React.render ( CustomFieldsEditor { dicts } ), container

      dicts = @_getCustomFieldsDicts()
      dicts.forEach (dict) ->
        dict.onUpdate = onUpdateDictionary

      React.render ( CustomFieldsEditor { dicts } ), container

  _industrySelectInDealEditTemplate: "<div id=\"taist-industryEditor\">\n  <div class=\"ContactFieldWidget\">\n    <div class=\"label\">industry:</div>\n    <div class=\"inputField taist-selectWrapper\"></div>\n\n    <div style=\"clear:both\"></div>\n  </div>\n</div>"
  _industrySelectInDealCreationTemplate: "<tr>\n  <td class=\"labelCell\">Industry:</td>\n</tr>\n<tr>\n  <td class=\'fieldCell\'>\n    <div class=\'nmbl-FormListBox\'>\n      <div class=\"taist-selectWrapper\">\n    </div>\n  </td>\n</tr>\n"
