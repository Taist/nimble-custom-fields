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
    div {}, [
      div {
        key: 'globalHeader'
        dangerouslySetInnerHTML:
          __html: require('../interface/dealListGroupGlobalHeader').apply(@)
      }
      div { key: 'dealList' }, @props.deals.map (group) -> { group: GroupContent group }
    ]

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

GroupHeader = React.createFactory React.createClass
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
  render: ->
    div {
      className: 'dealList'
      style:
        display: 'none'
    }, div { className: 'body' }, DealListBody @props

DealListBody = React.createFactory React.createClass
  getFullAmount: ->
    formatAmount @props.amount.full

  getWeightedAmount: ->
    formatAmount @props.amount.weighted

  render: ->
    div {}, [
      table { key: 'table'}, tbody {}, [
        @props.group.map (deal) ->
          { deal: DealListDeal deal }
      ]

      div {
        key: 'total'
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
