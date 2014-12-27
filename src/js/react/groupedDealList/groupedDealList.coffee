React = require 'react'

{ div } = React.DOM

GroupContent = require('./groupContent')

GroupedDealList = React.createFactory React.createClass
  render: ->
    div {}, [
      div {
        key: 'globalHeader'
        dangerouslySetInnerHTML:
          __html: require('./interface/globalHeader').apply(@)
      }
      div { key: 'dealList' }, @props.deals.map (group) -> { group: GroupContent group }
    ]

module.exports = GroupedDealList
