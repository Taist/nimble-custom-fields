app = require '../app'

isLoadingInProgress = false

renderDealList = () ->
  $('.groupGlobalHeader').parent().hide()
  $('.emptyView').hide()

  simpleList = $ '.mainContainer>div>.dealList'
  simpleList.parent().hide()

  container = $ '.dealListByIndustry'
  unless container.size()
    container = $ '<div class="dealListByIndustry">'
    container.insertBefore simpleList.parent()

  React = require 'react'

  {div, table, tbody} = React.DOM

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
        newExpandClass = if @state.expandClass is 'plus' then 'minus' else 'plus'
        target.removeClass(@state.expandClass).addClass(newExpandClass)
        @setState expandClass: newExpandClass
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
    getInitialState: ->
      groupInitialState()

    render: ->
      table {}, [
        tbody {}, [
          @props.group.map (deal) -> DealListDeal deal
        ]
      ]

  DealListDeal = React.createFactory React.createClass
    render: ->
      @expectedDate = new Date(@props.expected_close).toLocaleString(
        'en-us', { day: "numeric", month: "short", year: "numeric" }
      )
      div {
        dangerouslySetInnerHTML:
          __html: require('../interface/dealListDeal').apply(@)
      }

  groups = {}
  for id, deal of app.data.deals
    industry = deal.industry
    unless groups[industry]
      groups[industry] = []
    groups[industry].push deal

  grouppedDeals = []
  for name, group of groups
    amount =
      full: 0
      weighted: 0

    group.reduce (amount, deal) ->
      amount.full += deal.amount
      amount.weighted += deal.amount * deal.probability / 100
      return amount
    , amount

    grouppedDeals.push { name, group, amount }

  container.show()
  React.render ( GrouppedDealList { deals: grouppedDeals } ), container[0]

loadDeals = (page = 1) ->
  $.ajax
    url: '/api/deals'
    dataType: "json"
    headers:
      Authorization: "Nimble token=\"#{app.options.nimbleToken}\""
    data:
      sort_by: 'age'
      dir: 'asc'
      page: page
      per_page: app.options.dealsPerPage
    success: (data) ->
      processDeals data
      meta = data.meta
      if meta.has_more
        loadDeals meta.page + 1
      else
        isLoadingInProgress = false
        renderDealList()

processDeals = (deals) ->
  deals.resources.forEach (deal) ->

    #TODO Remove fake data
    category = parseInt( deal.id[23], 16 ) % 3
    deal.industry = switch category
      when 1 then 'Food'
      when 2 then 'Toys'
      else 'IT'

    app.data.deals[deal.id] = deal

module.exports = (groupingCondition) ->
  app.api.log 'Hello world', groupingCondition

  selector = '.listHeader .gwt-ListBox'
  app.api.wait.elementRender selector, (element) ->
    unless $('option[value="industry"]', element).size()
      groupingList = element[0]

      $ '<option value="industry">'
        .text 'Industry'
        .appendTo groupingList

      if groupingCondition is 'industry'
        $(groupingList).val('industry')

      groupingList.addEventListener 'change', ->
        app.api.log this.value

    if groupingCondition is 'industry'
      unless isLoadingInProgress
        isLoadingInProgress = true
        loadDeals()
