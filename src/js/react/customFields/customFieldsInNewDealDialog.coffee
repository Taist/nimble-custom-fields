React = require 'react'

{ div, table, tr, td } = React.DOM

CustomFieldsSelect = require './customFieldsSelect'
CustomFieldsText = require './customFieldsText'

editors =
  select: CustomFieldsSelect
  text: CustomFieldsText

CustomFieldsInNewDealDialog = React.createFactory React.createClass
  render: ->
    td { },
      @props.dicts.map (dict) =>
        table { key: dict.id, style: width: '100%' },
          tr {},
            td { className: 'labelCell' }, dict.name, ':'
          tr {},
            td { className: 'fieldCell', style: paddingRight: 5 },
              div { className: 'nmbl-FormListBox' },
                div { className: 'taist-selectWrapper' },
                  console.log dict
                  editors[dict.type] {
                    dict: dict
                    fields: @props.fields
                    onChange: @props.onChange
                    elemStyle: width: '100%'
                  }

module.exports = CustomFieldsInNewDealDialog
