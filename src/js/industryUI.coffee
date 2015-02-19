app = require './app'
React = require 'react'

module.exports =
  _getDealIdFromUrl: -> location.hash.substring((location.hash.indexOf '?id=') + 4)

  _getAddonContainer: (parent, element = 'div', shouldBeAppendedToParent = true) ->
    container = $('.taistContainer', parent)
    unless container.length
      container = $("<#{element} class=\"taistContainer\">")
      if shouldBeAppendedToParent
        container.appendTo parent
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
      customFieldEntity = app.repositories[id]?.getEntity(deal?[id])
      return {
        id: customFieldEntity?.id or 0
        name: repository.name
        value: customFieldEntity?.value or 'Not specified'
      }

  _renderInEditor: (parent, reactFieldsEditorClass) ->

  renderInNewDealDialog: ->
    app.api.wait.elementRender '.DealCreateForm tbody', (parent) =>
      container = @_getAddonContainer parent, 'tr', false

      $(container).insertAfter $('.fieldCell.stage', parent).parent()

      dicts = @_getCustomFieldsDicts()

      deal = {}
      fields = @_getCustomFieldsValues deal

      onChange = (dictId, optionId) ->
        deal[dictId] = optionId
        console.log 'onChange', deal

      CustomFieldsInNewDealDialog = require './react/customFields/customFieldsInNewDealDialog'
      React.render ( CustomFieldsInNewDealDialog { dicts, fields, onChange } ), container

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

      CustomFieldsInDealEditor = require './react/customFields/customFieldsInDealEditor'
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
