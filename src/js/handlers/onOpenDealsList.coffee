api = require '../globals/api'

module.exports = (groupingCondition) ->
  api.log 'Hello world ' + groupingCondition

  selector = '.listHeader .gwt-ListBox'
  api.wait.elementRender selector, (element) ->
    unless $('option[value="industry"]', element).size()
      groupingList = element[0]

      $ '<option value="industry">'
        .text 'Industry'
        .appendTo groupingList

      groupingList.addEventListener 'change', ->
        api.log this.value
