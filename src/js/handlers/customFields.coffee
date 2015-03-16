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
      type: repository.type

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

  editedDeals: []

  saveCustomFields: (dealId, isNew) ->
    console.log 'saveCustomFields', dealId, isNew
    editedDealId = if isNew then 'newDeal' else dealId
    if dealId
      if @editedDeals[editedDealId]
        deal = $.extend {}, @editedDeals[editedDealId], { id: dealId }
        delete @editedDeals[editedDealId]
        app.repositories.deals._saveEntity deal, =>
          console.log 'I belive it is successfuly saved - ', editedDealId, deal
          @renderInDealViewer()

  renderDealEditor: (dealId, CustomFieldDealEditor, container) ->
    dicts = @_getCustomFieldsDicts()

    delete @editedDeals[dealId]
    deal = {}
    unless dealId is 'newId'
      deal = $.extend {}, app.repositories.deals.getEntity( dealId ) or { id: dealId }

    fields = @_getCustomFieldsValues deal

    onChange = (dictId, value) =>
      #The function is called with editor as a context because of React
      deal[dictId] = value

      fields = thisModule._getCustomFieldsValues deal
      React.render ( CustomFieldDealEditor { dicts, fields, onChange } ), container

      thisModule.editedDeals[dealId] = deal

    React.render ( CustomFieldDealEditor { dicts, fields, onChange } ), container

  renderInNewDealDialog: ->
    app.api.wait.elementRender '.DealCreateForm>table>tbody', (parent) =>
      container = @_getAddonContainer parent, 'tr', false

      $(container).insertAfter $('.fieldCell.stage', parent).parent()

      CustomFieldDealEditor = require '../react/customFields/customFieldsInNewDealDialog'

      @renderDealEditor 'newDeal', CustomFieldDealEditor, container

  renderInDealEditor: ->
    app.api.wait.elementRender '.dealInfoTab .leftColumn', (parent) =>
      container = @_getAddonContainer parent

      CustomFieldDealEditor = require '../react/customFields/customFieldsInDealEditor'

      @renderDealEditor @_getDealIdFromUrl(), CustomFieldDealEditor, container

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

      reactRender = (alertMessage) ->
        React.render ( CustomFieldsEditor {
          dicts,
          onCreateNewCustomField
          alertMessage
        } ), container

      onUpdateDictionary = (entities) ->
        #The function is called with dict as a context because of React
        repoEntities = {}
        entities.forEach (entity) ->
          repoEntities[entity.id] = entity
        app.repositories[@id].save repoEntities, ->

        dicts.forEach (dict) =>
          if dict.id is @id
            dict.entities = entities
        reactRender()

      onChangeDictionaryName = (newName) ->
        #The function is called with dict as a context because of React
        dict = app.repositories.customFields.getEntity(@id)
        dict.name = newName
        app.repositories.customFields._saveEntity dict, ->

        dicts.forEach (dict) =>
          if dict.id is @id
            dict.name = newName
        reactRender()

      onDeleteDictionaryEntity = (deletedEntity) ->
        #The function is called with dict as a context because of React
        deals = app.repositories.deals.getAllEntities().filter (deal) =>
          deal[@id] is deletedEntity.id

        if deals.length > 0
          reactRender "Cannot delete '#{deletedEntity.value}' - it is used in some deals"
        else
          @onUpdate @entities.filter (entity) ->
            entity.id isnt deletedEntity.id

      onCreateNewCustomField = (name) ->
        app.repositories.customFields._saveEntity { name }, (dict) ->
          app.repositories[dict.id] = new entityRepository(app.api, dict.id)

          dict.entities = []
          dict.onUpdate = onUpdateDictionary
          dict.onRename = onChangeDictionaryName
          dict.onDelete = onDeleteDictionaryEntity

          dicts.push dict
          reactRender()

      dicts = @_getCustomFieldsDicts()
      dicts.forEach (dict) ->
        dict.onUpdate = onUpdateDictionary
        dict.onRename = onChangeDictionaryName
        dict.onDelete = onDeleteDictionaryEntity

      reactRender()
