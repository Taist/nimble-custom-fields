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
  render: ->
    (div {}, [
      GroupGlobalHeader {}
      GrouppedDealListBody @props
    ])

GrouppedDealListBody = React.createFactory React.createClass
  render: ->
    div {}, @props.deals.map (group) -> GroupContent group

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
      @forceUpdate()

  render: ->
    div {
      onClick: @onClick
      className: 'GroupDealListWidget'
    }, [
      GroupHeader @props
      DealList @props
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

  render: ->
    div {
      className: 'dealList'
      style:
        display: 'none'
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
