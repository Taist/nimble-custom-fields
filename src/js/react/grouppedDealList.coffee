React = require 'react'

{ div } = React.DOM

GroupContent = require('./grouppedDealList/groupContent')

GrouppedDealList = React.createFactory React.createClass
  render: ->
    div {}, [
      div {
        key: 'globalHeader'
        dangerouslySetInnerHTML:
          __html: require('../interface/dealListGroupGlobalHeader').apply(@)
      }
      div { key: 'dealList' }, @props.deals.map (group) -> { group: GroupContent group }
    ]

module.exports = GrouppedDealList
