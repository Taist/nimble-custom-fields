app = require './app'
selectField = require './objectsApi/selectField'

_deals = null
_industries = null

industryField = "industry"
industryNameField = "value"
notSpecifiedCaption = "Not specified"

module.exports =
  load: (callback) ->
    _deals = app.repositories.deals
    _industries = app.repositories.industry

    _industries.load ->
      _deals.load ->
        callback()

  createValueEditor: (dealId) ->
    entity = _deals.getOrCreateEntity dealId
    return @_createIndustryEditor (entity.getFieldValue industryField), (newValue) ->
      entity.setFieldValue industryField, newValue
      entity.save ->

  getIndustryName: (dealId) ->
    deal = _deals.getOrCreateEntity dealId
    industryId = deal.getFieldValue industryField
    console.log 'getIndustryName', dealId, industryId
    if industryId?
      industryName = (_industries.getEntity industryId)?.getFieldValue industryNameField

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
    industryListValues = ({id: industry._id, value: industry._data.value} for industry in @_getOrderedIndustriesList())
    console.log industryListValues.length
    industryListValues.unshift { id: 0, value: 'Not specified' }
    console.log industryListValues.length
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
    deal = _deals.getOrCreateEntity dealId
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
