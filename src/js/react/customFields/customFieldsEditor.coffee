React = require 'react'

{ div, h3, a } = React.DOM

DictEditor = require '../dictionaryEditor/dictEditor'
CustomFieldHeader = require './customFieldHeader'

CustomFieldsEditor = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'
    alertMessage: ''

  onEditMode: ->
    @setState {
      mode: 'edit'
      newDict:
        mode: 'new'
        name: ''
        onRename: @onCreateNewCustomField
        onCancel: => @setState mode: 'view'
    }

  onCreateNewCustomField: (fieldName, type) ->
    if fieldName.length > 0
      @props.onCreateNewCustomField?(fieldName, type)

  onCloseAlert: ->
     @setState alertMessage: ''

  alertTimeout: 5 * 1000

  componentWillReceiveProps: (newProps) ->
    @setState { alertMessage: newProps.alertMessage or '' }, ->
      if @state.alertMessage.length > 0
        setTimeout =>
          @onCloseAlert()
        , @alertTimeout

  render: ->
    div {},
      if @state.alertMessage.length > 0
        div {
          className: 'nmbl-StatusPanel nmbl-StatusPanel-warning'
          style:
            top: 60
            left: '50%'
            transform: 'translate(-50%, -50%)'
        },
          div { className: 'gwt-Label' }, @state.alertMessage
          div { className: 'closeOrange', onClick: @onCloseAlert }
      h3 {}, 'Custom fields'
      div {},
        if @state.mode is 'view'
          div { style: paddingLeft: 9, paddingTop: 5 },
            a { onClick: @onEditMode }, 'Add new custom field'
        else
          CustomFieldHeader @state.newDict
        div { style: { clear: 'both', height: 1 }, dangerouslySetInnerHTML: __html: '&nbsp;' }

      @props.dicts.map (dict) =>
        div { key: dict.id, style: marginTop: 32 },
          CustomFieldHeader dict
          if dict.type is 'select'
            DictEditor dict
          else
            div { style: clear: 'both', height: 8 }, ''

module.exports = CustomFieldsEditor
