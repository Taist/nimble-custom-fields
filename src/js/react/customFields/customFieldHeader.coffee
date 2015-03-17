React = require 'react'

{ div, span, a, select, option } = React.DOM

NimbleInlineEditor = require '../nimble/nimbleInlineEditor'

CustomFieldHeader = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'

  componentDidMount: () ->
    @setState mode: ( @props.mode or 'view' )

  fixedBlockStyle: (width = 200, style = {}) ->
    style.display = 'inline-block'
    style.width = width
    style

  onEdit: ->
    @setState { mode: 'edit' }

  closeEditor: ->
    @setState { mode: 'view' }
    @props.onCancel?()

  onSave: (newName) ->
    if @props.mode is 'new'
      type = @refs.fieldType.getDOMNode().value
      @props.onRename newName, type
    else
      @props.onRename newName

  render: ->
    div { className: 'subHeader' },
      if @state.mode is 'view'
        div {},
          div { style: @fixedBlockStyle() },
            @props.name,
            span { style: fontWeight: 'normal' }, 
              ' (' + (if @props.type is 'select' then 'list' else @props.type) + ')'
          div { style: @fixedBlockStyle(100) },
            a { onClick: @onEdit }, 'Rename field'
      else
        div { style: marginTop: -8, marginBottom: -6 },
          if @state.mode is 'new'
            div { style: display: 'inline-block'},
              div { style: display: 'inline-block', marginRight: 4 }, 'Type:'
              div { style: @fixedBlockStyle(100) },
                select { ref: 'fieldType', style: width: '100%' },
                  ['select', 'text'].map (type) ->
                    option { key: type, value: type }, if type is 'select' then 'list' else type
              div { style: display: 'inline-block', marginRight: 4, marginLeft: 12 }, 'Name:'
          NimbleInlineEditor {
            value: @props.name
            actions:
              onCancel: ->
              onSave: @onSave
            closeEditor: @closeEditor
          }

module.exports = CustomFieldHeader
