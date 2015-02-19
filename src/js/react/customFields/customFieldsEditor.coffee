React = require 'react'

{ div, h3 } = React.DOM

DictEditor = require '../dictionaryEditor/dictEditor'

CustomFieldsEditor = React.createFactory React.createClass
  render: ->
    div {},
      h3 {}, 'CUSTOM FIELDS BY TAIST'
      @props.dicts.map (dict) =>
        div { key: dict.id },
          DictEditor dict

module.exports = CustomFieldsEditor
