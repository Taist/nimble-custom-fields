app = require './app'
industryField = require './industryField'

module.exports =
  _industryForNewDeal: null
  renderInNewDealDialog: ->
    app.api.wait.elementRender '.DealCreateForm tbody', (dealCreateFormTable) =>
      industrySelectUI = $ @_industrySelectInDealCreationTemplate
      industryEditor = industryField.createValueEditorForNewDeal (selectedIndustry) =>
        @_industryForNewDeal = selectedIndustry
        app.api.log "industry for new deal: ", @_industryForNewDeal

      (industrySelectUI.find '.taist-selectWrapper').append industryEditor

      previousRow = (dealCreateFormTable.find '.fieldCell.stage').parent()

      console.log "rendering: ", industrySelectUI, dealCreateFormTable
      previousRow.after industrySelectUI

  renderInDealViewer: ->
    app.api.wait.elementRender '.DealView .generalInfo', (parentCell) =>
      @_saveIndustryForFreshlyCreatedDeal =>
        @_displayIndustryInDealViewer parentCell

  _saveIndustryForFreshlyCreatedDeal: (callback) ->
    if @_industryForNewDeal?
      industryField.setIndustryInDeal @_getDealIdFromUrl(), @_industryForNewDeal, =>
        @_industryForNewDeal = null
        callback()

    else
      callback()

  _displayIndustryInDealViewer: (parentCell) ->
    ($ '#taist-industryViewer').remove()
    parentCell.append """<div id=\"taist-industryViewer\" class=\"dealMainField\">Industry:&nbsp<div >#{industryField.getIndustryName @_getDealIdFromUrl()}</div> </div>"""

  renderInDealEditor: ->
    app.api.wait.elementRender '.dealInfoTab .leftColumn', (parentColumn) =>
      ($ '#taist-industryEditor').remove()
      industrySelectUI = $ @_industrySelectInDealEditTemplate
      (industrySelectUI.find '.taist-selectWrapper')
        .append(industryField.createValueEditor @_getDealIdFromUrl())
      parentColumn.append industrySelectUI

  _getDealIdFromUrl: -> location.hash.substring((location.hash.indexOf '?id=') + 4)

  renderInSettings: ->
    app.api.wait.elementRender '.SettingsDealsView', (parentEl) =>

      container = $('.taistSettingsContainer', parentEl)
      unless container.length
        container = $('<div class="taistSettingsContainer">').appendTo parentEl

      industryKey = 'type.industry.entities'

      React = require 'react'
      DictEditor = require './react/dictionaryEditor/dictEditor'

      repoEntities = app.repositories.industry.getAllEntities()
      dictEntities = []
      for id, entity of repoEntities
        data = entity._data
        data.id = entity._id
        dictEntities.push data

      dict =
        name: 'Industries'
        entities: dictEntities

        onUpdate: (entities) ->
          repoEntities = {}
          entities.forEach (entity) ->
            repoEntities[entity.id] = entity
          app.api.companyData.set industryKey, repoEntities, ->

          dict.entities = entities
          React.render ( DictEditor dict ), container[0]

      React.render ( DictEditor dict ), container[0]

  _industrySelectInDealEditTemplate: "<div id=\"taist-industryEditor\">\n  <div class=\"ContactFieldWidget\">\n    <div class=\"label\">industry:</div>\n    <div class=\"inputField taist-selectWrapper\"></div>\n\n    <div style=\"clear:both\"></div>\n  </div>\n</div>"
  _industrySelectInDealCreationTemplate: "<tr>\n  <td class=\"labelCell\">Industry:</td>\n</tr>\n<tr>\n  <td class=\'fieldCell\'>\n    <div class=\'nmbl-FormListBox\'>\n      <div class=\"taist-selectWrapper\">\n    </div>\n  </td>\n</tr>\n"
