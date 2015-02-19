Entity = require './entity'

whenjs = require 'when'

module.exports = class EntityRepository
  _entities: null
  _taistApi: null
  _entityTypeName: null

  _getEntityDataObjectName: ->
    "type.#{@_entityTypeName}.entities"

  constructor: (@_taistApi, @_entityTypeName) ->

  load: () ->
    @_loadEntityData()

  _updateEntities: (allEntitiesData) ->
    @_entities = allEntitiesData

  _loadEntityData: ->
    deferred = whenjs.defer()
    @_taistApi.companyData.get @_getEntityDataObjectName(), (err, allEntitiesData) =>
      if err
        deferred.reject err
      else
        deferred.resolve @_updateEntities allEntitiesData
    deferred.promise

  _saveEntity: (entity, callback) ->
    @_taistApi.companyData.setPart @_getEntityDataObjectName(), entity.id, entity, callback

  save: (entities, callback) ->
    @_taistApi.companyData.set @_getEntityDataObjectName(), entities, =>
      #TODO Fix it
      @_updateEntities(entities)
      callback()

  getEntity: (entityId) ->
    @_entities[entityId]

  getOrCreateEntity: (entityId) ->
    @_entities[entityId] ?= { id: entityId }

  getAllEntities: ->
    ( entity for id, entity of @_entities )

  getDictionary: ->
    ( $.extend({}, entity, { id }) for id, entity of @_entities )
