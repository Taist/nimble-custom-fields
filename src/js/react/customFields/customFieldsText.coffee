React = require 'react'

{ div, input } = React.DOM

CustomFieldsText = React.createFactory React.createClass
  onChange: ->
    newValue = @refs.editor.getDOMNode().value
    @props.onChange @props.dict.id, newValue

  render: ->
    console.log @props
    div {},
      input {
        ref: 'editor'
        type: 'text'
        className: 'nmbl-AdvancedTextBox'
        placeholder: @props.dict.name
        onChange: @onChange
      }

module.exports = CustomFieldsText
