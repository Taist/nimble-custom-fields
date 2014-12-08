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

groupInitialState = ->
  name: ''
  group: []
  amount:
    full: 0
    weighted: 0
  expandClass: 'plus'

GrouppedDealList = React.createFactory React.createClass
  render: ->
    div {}, [
      div {
        key: 'dealListGroupGlobalHeader'
        dangerouslySetInnerHTML:
          __html: require('../interface/dealListGroupGlobalHeader').apply(@)
      }
      div { key: 'grouppedDealList' }, @props.deals.map (group) -> { groupContent: GroupContent group }
    ]

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
      { groupHeader: GroupHeader @props }
      { dealList: DealList @props }
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
      key: @props.name
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
      div { key: 'dealListBody', className: 'body' }, DealListBody @props
    ]

DealListBody = React.createFactory React.createClass
  getFullAmount: ->
    formatAmount @props.amount.full

  getWeightedAmount: ->
    formatAmount @props.amount.weighted

  render: ->
    div {}, [
      table { key: 'dealTable'}, tbody {}, [
        @props.group.map (deal) ->
          { deal: DealListDeal deal }
      ]

      div {
        key: 'dealListTotal'
        dangerouslySetInnerHTML:
          __html: require('../interface/dealListTotalBlock').apply(@)
      }
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
