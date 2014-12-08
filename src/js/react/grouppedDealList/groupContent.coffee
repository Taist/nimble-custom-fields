React = require 'react'

{ div } = React.DOM

GroupHeader = require './groupHeader'
DealList = require './dealList'

GroupContent = React.createFactory React.createClass
  getInitialState: ->
    expandClass: 'plus'

  onClick: (event) ->
    target = $(event.target)
    if target.hasClass 'btnExpand'

      widget = target.parents '.GroupDealListWidget:first'
      if @state.expandClass is 'plus'
        expandClass = 'minus'
        $('.groupHeader .c1, .groupHeader .c2', widget).hide()
        $('.dealList', widget).show()
      else
        expandClass = 'plus'
        $('.groupHeader .c1, .groupHeader .c2', widget).show()
        $('.dealList', widget).hide()

      target.removeClass(@state.expandClass).addClass(expandClass)

      @setState { expandClass }

  render: ->
    div {
      onClick: @onClick
      className: 'GroupDealListWidget'
    }, [
      { header: GroupHeader @props }
      { list: DealList @props }
    ]

module.exports = GroupContent
