Entity = require './entity'

whenjs = require 'when'

module.exports = class EntityRepository
  _entities: null
  _taistApi: null
  _schema: null
  _entityTypeName: null

  _getEntityDataObjectName: ->
    "type.#{@_entityTypeName}.entities"

  constructor: (@_taistApi, @_entityTypeName, @_schema) ->

  load: () ->
    @_loadEntityData()

  _updateEntities: (allEntitiesData) ->
    @_entities = {}
    for entityId, entityData of allEntitiesData
      entityData = allEntitiesData[entityId]
      @_entities[entityId] = @_createEntity entityId, entityData

  _loadEntityData: ->
    deferred = whenjs.defer()
    @_taistApi.companyData.get @_getEntityDataObjectName(), (err, allEntitiesData) =>
      if err
        deferred.reject err
      else
        deferred.resolve @_updateEntities allEntitiesData
    deferred.promise

  _createEntity: (id, data) ->
    new Entity @, id, data

  _saveEntity: (entity, callback) ->
    @_taistApi.companyData.setPart @_getEntityDataObjectName(), entity._id, entity._data, callback

  save: (entities, callback) ->
    @_taistApi.companyData.set @_getEntityDataObjectName(), entities, =>
      #TODO Fix it
      @_updateEntities(entities)
      callback()

  getEntity: (entityId) ->
    @_entities[entityId]

  getOrCreateEntity: (entityId) ->
    @_entities[entityId] ?= @_createEntity entityId, {}

  getAllEntities: ->
    ( entity for id, entity of @_entities )

  getDictionary: ->
    ( $.extend({}, entity._data, { id }) for id, entity of @_entities )
