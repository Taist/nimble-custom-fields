React = require 'react'
formatAmount = require './formatAmount'

{ div } = React.DOM

GroupHeader = React.createFactory React.createClass
  getFullAmount: ->
    formatAmount @props.amount.full

  getWeightedAmount: ->
    formatAmount @props.amount.weighted

  render: ->
    div {
      dangerouslySetInnerHTML:
        __html: require('../../interface/dealListGroupHeader').apply(@)
    }

module.exports = GroupHeader
