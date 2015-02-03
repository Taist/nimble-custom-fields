app = require './app'
selectField = require './objectsApi/selectField'
entityRepository = require './objectsApi/entityRepository'

_deals = null
_industries = null

industryField = "industry"
industryNameField = "name"
notSpecifiedCaption = "Not specified"

module.exports =
  init: ->
    _deals = new entityRepository app.api, "deals", {fields: [industryField]}
    _industries = new entityRepository app.api, industryField, {fields: [industryNameField]}
#
  load: (callback) ->
    _deals.load ->
      _industries.load ->
        #stub for industries
        _industries._entities =
          1: _industries._createEntity 1, {name: "IT"}
          2: _industries._createEntity 2, {name: "Health"}
          3: _industries._createEntity 3, {name: "Transportation"}
          4: _industries._createEntity 4, {name: "Finance"}
        callback()

  createValueEditor: (dealId) ->
    entity = _deals.getEntity dealId
    return @_createIndustryEditor (entity.getFieldValue industryField), (newValue) ->
      entity.setFieldValue industryField, newValue
      entity.save ->

  getIndustryName: (dealId) ->
    deal = _deals.getEntity dealId
    industryId = deal.getFieldValue industryField
    if industryId?
      industryName = (_industries.getEntity industryId).getFieldValue industryNameField

    industryName ?= notSpecifiedCaption

  createIndustriesListEditor: ->
    #TODO - finish replicating UI for stages:
    # edit: pressing "Edit" should display separate form with editable industry name
    # deleting: should ask for confirmation - see native "Stages" UI
    # creating - display form similar to edit
    listEditorDiv = $ @_domTemplates.industriesList

    industriesTable = listEditorDiv.find '.industriesList tbody'

    for industry in @_getOrderedIndustriesList()
      industriesTable.append $ @_domTemplates.industryView industry

    return listEditorDiv

  _createIndustryEditor: (currentIndustryId, onValueChange) ->
    industryListValues = ({id: industry._id, value: industry.name} for industry in @_getOrderedIndustriesList())
    fieldUI = new selectField currentIndustryId, industryListValues, onValueChange
    return fieldUI.createValueEditor()

  _getOrderedIndustriesList: ->
    industriesList = _industries.getAllEntities()
    industriesList.sort (i1, i2) ->
      name1 = i1.getFieldValue industryNameField
      name2 = i2.getFieldValue industryNameField
      if name1 > name2
        return 1
      else if name1 < name2
        return -1
      else
        return 0

    return industriesList

  createValueEditorForNewDeal: (onValueChange) ->
    @_createIndustryEditor null, onValueChange

  setIndustryInDeal: (dealId, industryId, callback) ->
    deal = _deals.getEntity dealId
    deal.setFieldValue industryField, industryId
    deal.save callback

  _domTemplates:
    industriesList: """
      <div class="stagesContainer">
        <div class="tableHeaders">
          <div class="name">Name</div>
        </div>
        <div style="position: relative; overflow: hidden;">
          <table cellspacing="0" cellpadding="0" class="industriesList stageList">
            <tbody>
            </tbody>
          </table>
        </div>
      </div>
    """

    industryView: (industry) -> """
      <tr>
        <td align="left" style="vertical-align: top;">
          <div class="StageWidget taist-custom-field-settings-industry-edit">
            <div class="viewContainer">
              <div class="hoverContainer"><a class="gwt-Anchor delete taist-custom-field-delete-button" >Delete</a> <a class="gwt-Anchor ">Edit</a>

                <div style="clear:both"></div>
              </div>
              <div class="stageName">#{industry.getFieldValue "name"}</div>
            </div>

          </div>
        </td>
      </tr>

    """


