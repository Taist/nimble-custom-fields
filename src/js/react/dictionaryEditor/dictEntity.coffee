React = require 'react'

{ div, a, input } = React.DOM

NimbleAlert = require('../nimble/nimbleAlert')
NimbleInlineEditor = require('../nimble/nimbleInlineEditor')

DictEntity = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'

  fixedBlockStyle: (width = 200) ->
    display: 'inline-block'
    width: width

  onConfirmAlert: ->
    @setState { mode: 'onDelete' }

  onDelete: ->
    @props.actions.onDelete @props.entity.id
    @closeEditor()

  onEdit: ->
    @setState { mode: 'edit' }

  closeEditor: ->
    @setState { mode: 'view' }

  onSave: (newValue) ->
    @props.actions.onChange @props.entity.id, newValue

  showDictEntity: ->
    div { className: 'hasActivatedChildren', style: { padding: '15px 9px' } },
      div { style: @fixedBlockStyle() }, @props.entity.value
      div { style: @fixedBlockStyle(50) },
        a { onClick: @onEdit }, 'Edit'
      div { className: 'activatedByParent' },
        a { style: { color: 'red' }, onClick: @onConfirmAlert }, 'Delete'

  render: ->
    div { style: { borderBottom: '1px solid #f3f3f3' } },
    if @state.mode is 'view' and @props.entity.id
      @showDictEntity()
    else if @state.mode is 'onDelete'
      div {},
        @showDictEntity()
        NimbleAlert {
          message: "Are you sure, you want to delete #{@props.dictName}?"
          actionName: 'Delete'
          onAction: @onDelete
          onCancel: @closeEditor
        }
    else
      div { style: { padding: '8px 9px 7px 8px', backgroundColor: 'rgb(248, 248, 248)' } },
        NimbleInlineEditor {
          value: @props.entity.value
          actions:
            onCancel: @props.actions.onCancel
            onSave: @onSave
          closeEditor: @closeEditor
        }

module.exports = DictEntity
