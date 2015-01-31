Entity = require './entity'

module.exports = class EntityRepository
  _entities: null
  _taistApi: null
  _schema: null
  _entityTypeName: null

  _getEntityDataObjectName: -> """type.#{@_entityTypeName}.entities"""

  constructor: (@_taistApi, @_entityTypeName, @_schema) ->

  load: (callback) ->
    @_loadEntityData =>
      callback()

  _loadEntityData: (callback) ->
    @_taistApi.companyData.get @_getEntityDataObjectName(), (err, allEntitiesData) =>
      @_entities = {}
      for entityId, entityData of allEntitiesData
        entityData = allEntitiesData[entityId]
        @_entities[entityId] = @_createEntity entityId, entityData
      callback()

  _createEntity: (id, data) -> new Entity @, id, data

  _saveEntity: (entity, callback) -> @_taistApi.companyData.setPart @_getEntityDataObjectName(), entity._id, entity._data, callback

  getEntity: (entityId) ->
    @_entities[entityId] ?= @_createEntity entityId, {}

  getAllEntities: ->
    (entity for id, entity of @_entities)
