React = require 'react'

{ div, h3, a } = React.DOM

DictEditor = require '../dictionaryEditor/dictEditor'
DictHeader = require '../dictionaryEditor/dictHeader'
NimbleInlineEditor = require '../nimble/nimbleInlineEditor'

CustomFieldsEditor = React.createFactory React.createClass
  getInitialState: ->
    mode: 'view'

  onEditMode: ->
    @setState {
      mode: 'edit'
      newDict:
        mode: 'edit'
        name: ''
        onRename: @onCreateNewCustomField
        onCancel: => @setState mode: 'view'
    }

  onCreateNewCustomField: (fieldName) ->
    console.log fieldName
    if fieldName.length > 0
      @props.onCreateNewCustomField?(fieldName)

  render: ->
    div {},
      h3 {}, 'CUSTOM FIELDS BY TAIST'
      div {},
        if @state.mode is 'view'
          div { style: paddingLeft: 9, paddingTop: 5 },
            a { onClick: @onEditMode }, 'Add new custom field'
        else
          DictHeader @state.newDict
        div { style: { clear: 'both', height: '1px' }, dangerouslySetInnerHTML: __html: '&nbsp;' }

      @props.dicts.map (dict) =>
        div { key: dict.id },
          DictHeader dict
          DictEditor dict

module.exports = CustomFieldsEditor
