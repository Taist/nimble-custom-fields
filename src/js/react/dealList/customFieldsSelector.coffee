React = require 'react'

{ div, span, label, input } = React.DOM

AwesomeIcons = require '../taist/awesomeIcons'

CustomFieldsSelector = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'

  onSwitchMode: ->
    @setState mode: if @state.mode is 'view' then 'select' else 'view'

  onChangeFieldSelection: (fieldName, isSelected) ->
    @props.onChange?( fieldName, isSelected )

  render: ->
    div {},
      div {
        onClick: @onSwitchMode
        className: 'gwt-Label-fieldName'
        style:
          cursor: 'pointer'
          backgroundImage: AwesomeIcons.getURL 'gear', 'gray40'
          backgroundSize: 'contain'
          backgroundRepeat: 'no-repeat'

          color: '#666'
          paddingLeft: 18
          marginTop: 4
      }, 'Displayed custom fields'


      if @state.mode is 'select'
        div {
          style:
            background: 'white'
            padding: 4
            marginTop: 4
            border: '1px solid silver'
            position: 'absolute'
            minWidth: 200
        },
          div { style: textAlign: 'right' },
            span {
              onClick: @onSwitchMode
              style:
                width: 16
                cursor: 'pointer'
                backgroundImage: AwesomeIcons.getURL 'remove'
                backgroundSize: 'contain'
                backgroundRepeat: 'no-repeat'
                paddingLeft: 16
                opacity: 0.65
            }, ' '

          @props.fields.map (field) =>
            isSelected = !!@props.selected[field.name]
            div {
              key: field.name,
              style:
                padding: 2
            },
              label {},
                input {
                  type: 'checkbox'
                  checked: isSelected
                  onChange: => @onChangeFieldSelection field.name, !isSelected
                }
                field.name

module.exports = CustomFieldsSelector
