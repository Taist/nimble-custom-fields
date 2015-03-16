React = require 'react'

{ div } = React.DOM

CustomFieldsSelect = require './CustomFieldsSelect'

CustomFieldsInDealEditor = React.createFactory React.createClass
  render: ->
    div {},
      @props.dicts.map (dict) =>
        div { key: dict.id },
          div { className: 'ContactFieldWidget' },
            div { className: 'label' }, dict.name
            div { className: 'inputField taist-selectWrapper' },
              CustomFieldsSelect {
                dict: dict,
                fields: @props.fields,
                onChange: @props.onChange
              }
            div { style: clear: 'both' }, ''

module.exports = CustomFieldsInDealEditor
