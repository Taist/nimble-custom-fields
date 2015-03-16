React = require 'react'

{ div, input } = React.DOM

CustomFieldsText = React.createFactory React.createClass
  onChange: ->

  render: ->
    console.log @props
    div {},
      input {
        type:'text'
        className: 'nmbl-AdvancedTextBox'
        placeholder: @props.dict.name
      }

module.exports = CustomFieldsText
