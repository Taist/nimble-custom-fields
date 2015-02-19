React = require 'react'

{ select, option } = React.DOM

defaultSelectValue = { id: 0, value: 'Not specified' }

CustomFieldsSelect = React.createFactory React.createClass
  onChange: ->
    @props.onChange @props.dict.id, @refs.select.getDOMNode().value

  render: ->
    dict = @props.dict

    currentFieldValue = @props.fields?.filter (field) =>
      field.name is dict.name

    select {
      ref: 'select'
      onChange: @onChange
      defaultValue: currentFieldValue[0]?.id or 0
      style: @props.selectStyle
    },
      [defaultSelectValue].concat(dict.entities).map (entity) =>
        option { key: entity.id, value: entity.id }, entity.value

module.exports = CustomFieldsSelect
