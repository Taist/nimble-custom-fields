EntityType = require './entityType'

module.exports =
  _typeSchemas: {}
  _taistApi: null
  getType: (name) ->
    schema = @_typeSchemas[name]
    if not schema?
      throw new Exception "Attempt to get type " + name + " that is not set yet"

    return new EntityType @_taistApi, name, schema

  registerType: (name, schema) -> @_typeSchemas[name] = schema

  fieldEditors:
    select: require './selectField'
  


