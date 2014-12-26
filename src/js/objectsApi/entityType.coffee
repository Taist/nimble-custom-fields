Entity = require './entity'

module.exports = class EntityType
  _entities: null
  _taistApi: null
  _schema: null
  _name: null
  _fieldSettings: null

  _getEntityDataObjectName: -> """type.#@_name.entities"""

  _getFieldSettingsDataObjectName: ->
    return "type." + @_name + ".fieldSettings"


  constructor: (@_taistApi, @_name, @_schema) ->

  load: (callback) ->
    @_loadEntityData =>
      @_loadFieldSettings ->
        callback()

  _loadEntityData: (callback) ->
    @_taistApi.companyData.get @_getEntityDataObjectName(), (err, allEntitiesData) =>
      @_taistApi.log "entities data: ", allEntitiesData
      @_entities = {}
      for entityId, entityData of allEntitiesData
        entityData = allEntitiesData[entityId]
        @_entities[entityId] = @_createEntity entityId, entityData
      callback()

  _loadFieldSettings: (callback) ->
    @_taistApi.companyData.get @_getFieldSettingsDataObjectName(), (err, res) =>
      @_fieldSettings = res ? {}
      callback()

  _createEntity: (id, data) -> new Entity @, id, data

  _saveEntity: (entity, callback) -> @_taistApi.companyData.setPart @_getEntityDataObjectName(), entity._id, entity._data, callback

  getEntity: (entityId) ->
    @_entities[entityId] ?= @_createEntity entityId, {}


  getFieldValueEditor: (fieldName, entity) ->
    fieldOptions = @_schema.fields[fieldName]
    fieldUIConstructor = @_taistApi.objects.fieldEditors[fieldOptions.type]
    fieldUI = new fieldUIConstructor entity, fieldName, fieldOptions, @_getFieldSettings fieldName
    return fieldUI


  _getFieldSettings: (fieldName) -> @_fieldSettings[fieldName] ?= {}

  createFieldSettingsEditor: (fieldName) ->
    fieldOptions = @_schema.fields[fieldName]
    fieldUIConstructor = @_taistApi.objects.fieldEditors[fieldOptions.type]
    settingsUpdateCallback = (newSettings) =>
      @_fieldSettings[fieldName] = newSettings
      @_saveFieldSettings()

    return fieldUIConstructor.createSettingsEditor @_getFieldSettings(fieldName), settingsUpdateCallback


  _saveFieldSettings: -> @_taistApi.companyData.set @_getFieldSettingsDataObjectName(), @_fieldSettings, ->

