React = require 'react'

{ div, table, tr, td } = React.DOM

CustomFieldsSelect = require './CustomFieldsSelect'

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
                  CustomFieldsSelect {
                    dict: dict
                    fields: @props.fields
                    onChange: @props.onChange
                    selectStyle: width: '100%'
                  }

module.exports = CustomFieldsInNewDealDialog
