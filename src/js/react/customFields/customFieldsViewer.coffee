React = require 'react'

{ div } = React.DOM

CustomFieldsViewer = React.createFactory React.createClass
  render: ->
    div {},
      @props.fields.map (field) =>
        div { key: field.name },
          div { className: 'dealMainField', style: marginBottom: 2 }, field.name, ':',
            div { style: paddingLeft: 5 }, field.value

module.exports = CustomFieldsViewer
