React = require 'react'

{ select, option } = React.DOM

defaultSelectValue = { id: 0, value: 'Not specified' }

CustomFieldsSelect = React.createFactory React.createClass
  onChange: ->
    newValue = @refs.select.getDOMNode().value
    @props.onChange @props.dict.id, newValue

  render: ->
    currentFieldValue = @props.fields?.filter (field) =>
      field.name is @props.dict.name

    select {
      ref: 'select'
      onChange: @onChange
      value: currentFieldValue[0]?.id or 0
      style: @props.elemStyle
    },
      [defaultSelectValue].concat(@props.dict.entities).map (entity) =>
        option { key: entity.id, value: entity.id }, entity.value

module.exports = CustomFieldsSelect
