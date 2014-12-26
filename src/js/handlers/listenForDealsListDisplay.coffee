app = require '../app'
dealListPattern = /app\/deals\/list/

module.exports = ->
  return app.api.hash.onChange (cur, old) ->
    if cur?.match dealListPattern
      matches = cur.match /grouped_by=([^&]+)/
      groupingCondition = matches?[1] ? 'none'
      ($ '.dealListByIndustry').hide()
      if groupingCondition is 'industry' or not (old?.match dealListPattern)
        (require '../handlers/onOpenDealsList') groupingCondition
