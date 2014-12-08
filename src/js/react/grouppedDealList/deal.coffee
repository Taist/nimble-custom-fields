React = require 'react'
formatAmount = require './formatAmount'

{ div } = React.DOM

Deal = React.createFactory React.createClass
  getAmount: ->
    formatAmount @props.amount

  getContactLink: ->
    unless @props.related_primary?[1]
      return '-'
    '
    <a href="#app/contacts/view?id=' + @props.related_primary[0] + '">
    ' + @props.related_primary[1] + '
    </a>'

  render: ->
    @expectedDate = new Date(@props.expected_close).toLocaleString(
      'en-us', { day: "numeric", month: "short", year: "numeric" }
    )
    div {
      dangerouslySetInnerHTML:
        __html: require('../../interface/dealListDeal').apply(@)
    }

module.exports = Deal
