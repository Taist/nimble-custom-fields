module.exports = class Entity
  _data: null
  _id: null
  _entityType: null

  constructor: (@_entityType, @_id, @_data) ->

  getFieldValue: (fieldName) -> @_data[fieldName]

  setFieldValue: (fieldName, newValue) -> @_data[fieldName] = newValue

  save: (callback) -> @_entityType._saveEntity(this, callback)
  

