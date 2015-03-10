React = require 'react'

{ div, a } = React.DOM

DictEntity = require './dictEntity'

DictEditor = React.createFactory React.createClass
  getInitialState: ->
    newEntity: null

  onDelete: (entityId) ->
    @props.onDelete entityId

  onChange: (entityId, newValue) ->
    if entityId
      @props.onUpdate @props.entities.map (entity) ->
        if entity.id is entityId then entity.value = newValue
        entity
    else
      @setState newEntity: null
      entityId = new Date().getTime() + Math.random()
      @props.onUpdate @props.entities.concat { id: entityId, value: newValue }

  onAdd: () ->
    @setState newEntity: { id: null, value: '' }

  onCancel: () ->
    @setState newEntity: null

  render: ->
    div { style: { marginTop: 32, width: 565 } },
      div { style: { clear: 'both', height: '1px' }, dangerouslySetInnerHTML: __html: '&nbsp;' }
      div { style: { marginTop: '15px', borderTop: '1px solid #f3f3f3' } },
        @props.entities.concat(@state.newEntity).map (entity) =>
          if entity
            div { key: entity.id or 'new' }, DictEntity
              entity: entity
              dictName: @props.name
              actions:
                onDelete: @onDelete
                onChange: @onChange
                onCancel: @onCancel
      unless @state.newEntity
        div { style: { padding: '8px 9px 32px 9px', borderTop: '1px solid #f3f3f3' } },
          a { onClick: @onAdd }, "Add  #{@props.name}"

module.exports = DictEditor
