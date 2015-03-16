React = require 'react'

{ select, option } = React.DOM

defaultSelectValue = { id: 0, value: 'Not specified' }

CustomFieldsSelect = React.createFactory React.createClass
  onChange: ->
    newValue = @refs.select.getDOMNode().value
    @props.onChange @props.dict.id, newValue

  render: ->
    select {
      ref: 'select'
      onChange: @onChange
      value: @props.value
      style: @props.elemStyle
    },
      [defaultSelectValue].concat(@props.dict.entities).map (entity) =>
        option { key: entity.id, value: entity.id }, entity.value

module.exports = CustomFieldsSelect
