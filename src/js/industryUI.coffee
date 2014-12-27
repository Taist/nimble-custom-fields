app = require './app'
industryField = require './industryField'

module.exports =
  renderInDealViewer: ->
    app.api.wait.elementRender '.DealView .generalInfo', (parentCell) =>
      ($ '#taist-industryViewer').remove()
      parentCell.append """<div id=\"taist-industryViewer\" class=\"dealMainField\">Industry:&nbsp<div >#{industryField.getValueToDisplay @_getDealIdFromUrl()}</div> </div>"""

  renderInDealEditor: ->
    app.api.wait.elementRender '.dealInfoTab .leftColumn', (parentColumn) =>
      ($ '#taist-industryEditor').remove()
      industrySelectUI = $ @_industrySelectTemplate
      (industrySelectUI.find '.taist-selectWrapper').append(industryField.createValueEditor @_getDealIdFromUrl())
      parentColumn.append industrySelectUI

  _getDealIdFromUrl: -> location.hash.substring((location.hash.indexOf '?id=') + 4)

  renderInSettings: ->
    app.api.wait.elementRender '.SettingsDealsView', (parentEl) =>
      $('.taistSettingsContainer').remove()
      settingsWrapperEl = $ """<div class="taistSettingsContainer"><div class="subHeader">Industries</div><br/><br/></div>"""
      parentEl.append settingsWrapperEl
      industrySettingsUI = industryField.createSettingsEditor()
      settingsWrapperEl.append industrySettingsUI

  _industrySelectTemplate: "<div id=\"taist-industryEditor\">\n  <div class=\"ContactFieldWidget\">\n    <div class=\"label\">industry:</div>\n    <div class=\"inputField taist-selectWrapper\">\n    </div>\n    <img class=\"btnDelete\" src=\"./application/resources/hovericons/ico_delete_large_sub.png\" style=\"display:none\">\n\n    <div style=\"clear:both\"></div>\n  </div>\n  <a class=\"addField\" href=\"javascript:\" style=\"display: none\">assigned to</a></div>"


