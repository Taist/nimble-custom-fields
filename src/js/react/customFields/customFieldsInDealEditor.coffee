React = require 'react'

{ div, select, option } = React.DOM

defaultSelectValue = { id: 0, value: 'Not specified' }

CustomFieldsSelect = React.createFactory React.createClass
  onChange: ->
    @props.onChange @props.dict.id, @refs.select.getDOMNode().value

  render: ->
    dict = @props.dict

    currentFieldValue = @props.fields?.filter (field) =>
      field.name is dict.name

    select { ref: 'select', onChange: @onChange, defaultValue: currentFieldValue[0]?.id or 0 },
      [defaultSelectValue].concat(dict.entities).map (entity) =>
        option { key: entity.id, value: entity.id }, entity.value


CustomFieldsInDealEditor = React.createFactory React.createClass
  render: ->
    div {},
      @props.dicts.map (dict) =>
        div { key: dict.id },
          div { className: 'ContactFieldWidget' },
            div { className: 'label' }, dict.name
            div { className: 'inputField taist-selectWrapper' },
              CustomFieldsSelect { dict, fields: @props.fields, onChange: @props.onChange }
            div { style: clear: 'both' }, ''

module.exports = CustomFieldsInDealEditor
