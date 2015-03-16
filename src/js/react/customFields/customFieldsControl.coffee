React = require 'react'

# { div } = React.DOM

CustomFieldsSelect = require './customFieldsSelect'
CustomFieldsText = require './customFieldsText'

editors =
  select: CustomFieldsSelect
  text: CustomFieldsText

CustomFieldsInNewDealDialog = React.createFactory React.createClass
  render: ->
    currentFieldValue = @props.fields?.filter (field) =>
      field.name is @props.dict.name

    switch @props.dict.type
      when 'select' then value = currentFieldValue[0]?.id or 0
      when 'text' then value = currentFieldValue[0]?.value or ''

    editors[@props.dict.type] {
      dict: @props.dict
      fields: @props.fields
      onChange: @props.onChange
      elemStyle: @props.elemStyle
      value
    }

module.exports = CustomFieldsInNewDealDialog
