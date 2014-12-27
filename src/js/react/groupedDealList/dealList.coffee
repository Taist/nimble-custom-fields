React = require 'react'
formatAmount = require './formatAmount'

{ div, table, tbody } = React.DOM

Deal = require './deal'

DealList = React.createFactory React.createClass
  getFullAmount: ->
    formatAmount @props.amount.full

  getWeightedAmount: ->
    formatAmount @props.amount.weighted

  render: ->
    ( div {
      className: 'dealList'
      style:
        display: 'none'
    },
      (div { className: 'body' }, [
        table { key: 'table'}, tbody {}, [
          @props.group.map (deal) ->
            { deal: Deal deal }
        ]

        div {
          key: 'total'
          dangerouslySetInnerHTML:
            __html: require('./interface/totalBlock').apply(@)
        }
      ])
    )

module.exports = DealList
