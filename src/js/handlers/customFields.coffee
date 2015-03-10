app = require '../app'
React = require 'react'

entityRepository = require '../objectsApi/entityRepository'

module.exports = thisModule =
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

  _newDealCustomFields: null

  renderInNewDealDialog: ->
    app.api.wait.elementRender '.DealCreateForm>table>tbody', (parent) =>
      container = @_getAddonContainer parent, 'tr', false

      $(container).insertAfter $('.fieldCell.stage', parent).parent()

      dicts = @_getCustomFieldsDicts()

      @_newDealCustomFields = null;
      deal = {}
      fields = @_getCustomFieldsValues deal

      CustomFieldsInNewDealDialog = require '../react/customFields/customFieldsInNewDealDialog'

      onChange = (dictId, optionId) =>
        #The function is called with select as a context because of React
        deal[dictId] = optionId

        fields = thisModule._getCustomFieldsValues deal
        React.render ( CustomFieldsInNewDealDialog { dicts, fields, onChange } ), container

        thisModule._newDealCustomFields = deal

      React.render ( CustomFieldsInNewDealDialog { dicts, fields, onChange } ), container

  saveCustomFieldsForNewDeal: (dealId) ->
    if dealId and @_newDealCustomFields
      deal = $.extend { id: dealId }, @_newDealCustomFields
      @_newDealCustomFields = null
      app.repositories.deals._saveEntity deal, =>
        console.log 'I belive it is successfuly saved', deal
        @renderInDealEditor()

  renderInDealEditor: ->
    app.api.wait.elementRender '.dealInfoTab .leftColumn', (parent) =>
      container = @_getAddonContainer parent

      dicts = @_getCustomFieldsDicts()

      deal = app.repositories.deals.getEntity( @_getDealIdFromUrl() ) or { id: @_getDealIdFromUrl() }
      fields = @_getCustomFieldsValues deal

      CustomFieldsInDealEditor = require '../react/customFields/customFieldsInDealEditor'

      onChange = (dictId, optionId) ->
        #The function is called with select as a context because of React
        deal[dictId] = optionId

        fields = thisModule._getCustomFieldsValues deal
        React.render ( CustomFieldsInDealEditor { dicts, fields, onChange } ), container

        app.repositories.deals._saveEntity deal, ->
          console.log 'I belive it is successfuly saved', dictId, optionId

      React.render ( CustomFieldsInDealEditor { dicts, fields, onChange } ), container

  renderInDealViewer: ->
    app.api.wait.elementRender '.DealView .generalInfo', (parent) =>
      container = @_getAddonContainer parent

      fields = @_getCustomFieldsValues()

      CustomFieldsViewer = require '../react/customFields/CustomFieldsViewer'
      React.render ( CustomFieldsViewer { fields } ), container

  renderInSettings: ->
    app.api.wait.elementRender '.SettingsDealsView', (parent) =>

      container = @_getAddonContainer parent
      CustomFieldsEditor = require '../react/customFields/CustomFieldsEditor'

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

      onChangeDictionaryName = (newName) ->
        #The function is called with dict as a context because of React
        dict = app.repositories.customFields.getEntity(@id)
        dict.name = newName
        app.repositories.customFields._saveEntity dict, ->

        dicts.forEach (dict) =>
          if dict.id is @id
            dict.name = newName
        React.render ( CustomFieldsEditor { dicts } ), container

      onDeleteDictionaryEntity = (entityId) ->
        #The function is called with dict as a context because of React
        deals = app.repositories.deals.getAllEntities().filter (deal) =>
          deal[@id] is entityId

        if deals.length > 0
          React.render ( CustomFieldsEditor {
            dicts
            onCreateNewCustomField
            alertMessage : 'Error deleting custom field value. Is is linked to some existed deal' 
          } ), container
        else
          @onUpdate @entities.filter (entity) ->
            entity.id isnt entityId

      onCreateNewCustomField = (name) ->
        app.repositories.customFields._saveEntity { name }, (dict) ->
          app.repositories[dict.id] = new entityRepository(app.api, dict.id)

          dict.entities = []
          dict.onUpdate = onUpdateDictionary
          dict.onRename = onChangeDictionaryName
          dict.onDelete = onDeleteDictionaryEntity

          dicts.push dict
          React.render ( CustomFieldsEditor { dicts } ), container

      dicts = @_getCustomFieldsDicts()
      dicts.forEach (dict) ->
        dict.onUpdate = onUpdateDictionary
        dict.onRename = onChangeDictionaryName
        dict.onDelete = onDeleteDictionaryEntity

      React.render ( CustomFieldsEditor { dicts, onCreateNewCustomField } ), container
