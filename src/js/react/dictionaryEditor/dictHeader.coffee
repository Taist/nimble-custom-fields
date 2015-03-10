React = require 'react'

{ div, a } = React.DOM

DictHeader = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'

  componentDidMount: () ->
    @setState mode: ( @props.mode or 'view' )

  fixedBlockStyle: (width = 200) ->
    display: 'inline-block'
    width: width

  onEdit: ->
    @setState { mode: 'edit' }

  closeEditor: ->
    @setState { mode: 'view' }
    @props.onCancel?()


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

module.exports = DictHeader
