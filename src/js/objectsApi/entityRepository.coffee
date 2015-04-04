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
        deferred.resolve @_updateEntities(allEntitiesData or [])
    deferred.promise

  _saveEntity: (entity, callback) ->
    unless entity.id
      entity.id = new Date().getTime() + Math.random()

    @_taistApi.companyData.setPart @_getEntityDataObjectName(), entity.id, entity, =>
      @_entities[entity.id] = entity
      callback(entity)

  save: (entities, callback) ->
    @_taistApi.companyData.set @_getEntityDataObjectName(), entities, =>
      #TODO Fix it
      @_updateEntities(entities)
      callback()

  remove: (entityId, callback) ->
    delete @_entities[entityId]
    @save @_entities, callback

  getEntity: (entityId) ->
    @_entities[entityId]

  getAllEntities: ->
    ( entity for id, entity of @_entities )

  getDictionary: ->
    dictEntities = ( $.extend({}, entity, { id }) for id, entity of @_entities )
    dictEntities.sort (a, b) ->
      if a.value > b.value then 1 else -1
    return dictEntities
