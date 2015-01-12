entityRepository = require './entityRepository'

module.exports = class EntityForm
  _entityRepository: null

  constructor: (@_entityRepository) ->

