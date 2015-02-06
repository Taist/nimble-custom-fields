React = require 'react'

{ div, a } = React.DOM

DictEntity = require('./dictEntity')

DictEditor = React.createFactory React.createClass
  getInitialState: ->
    newEntity: null

  onDelete: (entityId) ->
    @props.onUpdate @props.entities.filter (entity) ->
      entity.id isnt entityId

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
    div { style: { marginTop: 30, width: 565 } },
      div { className: 'subHeader' },
        @props.name
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
        div { style: { padding: '15px 9px' } },
          a { onClick: @onAdd }, "Add  #{@props.name}"

module.exports = DictEditor
