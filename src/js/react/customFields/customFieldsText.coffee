React = require 'react'

{ div, input } = React.DOM

CustomFieldsText = React.createFactory React.createClass
  onChange: ->
    newValue = @refs.editor.getDOMNode().value
    @props.onChange @props.dict.id, newValue

  render: ->
    div {},
      input {
        ref: 'editor'
        type: 'text'
        value: @props.value
        className: 'nmbl-AdvancedTextBox'
        placeholder: @props.dict.name
        onChange: @onChange
      }

module.exports = CustomFieldsText
