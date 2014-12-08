React = require 'react'

formatAmount = (amount) ->
  unless amount
    return '-'

  digits = amount.toString().split('')
  groups = []
  while digits.length
    groups.unshift digits.splice(-3).join('')
  '$ ' + groups.join()

{ div, table, tbody } = React.DOM

GrouppedDealList = React.createFactory React.createClass
  getInitialState: ->
    deals: []
  render: ->
    div {}, [
      GroupGlobalHeader {}
      div {}, @props.deals.map((deal) -> GroupContent deal )
    ]

GroupGlobalHeader = React.createFactory React.createClass
  render: ->
    div {
      dangerouslySetInnerHTML:
        __html: require('../interface/dealListGroupGlobalHeader').apply(@)
    }

groupInitialState = ->
  name: ''
  group: []
  amount:
    full: 0
    weighted: 0
  expandClass: 'plus'

GroupContent = React.createFactory React.createClass
  getInitialState: ->
    groupInitialState()

  onClick: (event) ->
    target = $(event.target)
    if target.hasClass 'btnExpand'

      header = target.parents '.groupHeader:first'
      if @state.expandClass is 'plus'
        expandClass = 'minus'
        $('.c1, .c2', header).hide()
      else
        expandClass = 'plus'
        $('.c1, .c2', header).show()

      target.removeClass(@state.expandClass).addClass(expandClass)

      @setState { expandClass }
      @forceUpdate()

  render: ->
    div {
      onClick: @onClick
      className: 'GroupDealListWidget'
    }, [
      GroupHeader @props
      DealList $.extend true, {}, @props, expandClass: @state.expandClass
    ]

GroupHeader = React.createFactory React.createClass
  getInitialState: ->
    groupInitialState()

  getFullAmount: ->
    formatAmount @props.amount.full

  getWeightedAmount: ->
    formatAmount @props.amount.weighted

  render: ->
    div {
      dangerouslySetInnerHTML:
        __html: require('../interface/dealListGroupHeader').apply(@)
    }

DealList = React.createFactory React.createClass
  getInitialState: ->
    groupInitialState()

  display: ->
    if @props.expandClass is 'plus' then 'none' else 'block'

  render: ->
    div {
      className: 'dealList'
      style:
        display: @display()
    }, [
      DealListHeader {}
      div { className: 'body' }, DealListBody @props
    ]

DealListHeader = React.createFactory React.createClass
  render: ->
    div {
      dangerouslySetInnerHTML:
        __html: require('../interface/dealListHeader').apply(@)
    }

DealListBody = React.createFactory React.createClass
  getFullAmount: ->
    formatAmount @props.amount.full

  getWeightedAmount: ->
    formatAmount @props.amount.weighted

  getInitialState: ->
    groupInitialState()

  render: ->
    table {}, [
      tbody {}, [
        @props.group.map (deal) -> DealListDeal deal
        div {
          dangerouslySetInnerHTML:
            __html: require('../interface/dealListTotalBlock').apply(@)
        }
      ]
    ]

DealListDeal = React.createFactory React.createClass
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
        __html: require('../interface/dealListDeal').apply(@)
    }

module.exports = GrouppedDealList
