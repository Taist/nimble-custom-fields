React = require 'react'

{ div, h3, a } = React.DOM

DictEditor = require '../dictionaryEditor/dictEditor'
NimbleInlineEditor = require '../nimble/nimbleInlineEditor'

DictHeader = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'

  fixedBlockStyle: (width = 200) ->
    display: 'inline-block'
    width: width

  onEdit: ->
    @setState { mode: 'edit' }

  closeEditor: ->
    @setState { mode: 'view' }

  onSave: (newName) ->
    @props.onRename newName

  render: ->
    div { className: 'subHeader' },
      if @state.mode is 'view'
        div {},
          div { style: @fixedBlockStyle() }, @props.name
          div { style: @fixedBlockStyle(50) },
            a { onClick: @onEdit }, 'Edit'
      else
        div { style: marginTop: -8, marginBottom: -6 },
          NimbleInlineEditor {
            value: @props.name
            actions:
              onCancel: ->
              onSave: @onSave
            closeEditor: @closeEditor
          }

CustomFieldsEditor = React.createFactory React.createClass
  render: ->
    div {},
      h3 {}, 'CUSTOM FIELDS BY TAIST'
      @props.dicts.map (dict) =>
        div { key: dict.id },
          DictHeader dict
          DictEditor dict

module.exports = CustomFieldsEditor
