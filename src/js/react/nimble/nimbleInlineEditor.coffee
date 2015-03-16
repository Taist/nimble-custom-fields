React = require 'react'

{ div, a, input } = React.DOM

NimbleInlineEditor = React.createFactory React.createClass
  createButton: (name, onClickHandler) ->
    options =
      tabIndex: 0,
      className: 'nmbl-Button nmbl-Button-WebkitGecko'
      style: { marginLeft: 12 }
      onClick: onClickHandler
    div options, div { className: 'nmbl-ButtonContent' }, name

  onCancel: ->
    @props.actions.onCancel()
    @props.closeEditor()

  onSave: ->
    @props.actions.onSave @refs.valueEditor.getDOMNode().value
    @props.closeEditor()

  render: ->
    div { className: 'nmbl-FormTextBox nmbl-FormTextBox-name', style: display: 'inline-block' },
      input
        ref: 'valueEditor'
        className: 'nmbl-AdvancedTextBox'
        type: 'text'
        maxLength: '256'
        defaultValue: @props.value
        autoFocus: true
      @createButton 'Save', @onSave
      @createButton 'Cancel', @onCancel

module.exports = NimbleInlineEditor
