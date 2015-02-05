EntityRepository = require './entityRepository'

module.exports =
  _typeSchemas: {}
  _taistApi: null
  getTypeRepository: (name) ->
    schema = @_typeSchemas[name]
    if not schema?
      throw """Attempt to get type #{name} that is not registered yet"""

    return new EntityRepository @_taistApi, name, schema

  registerType: (name, schema) -> @_typeSchemas[name] = schema

  fieldEditors:
    select: require './selectField'
