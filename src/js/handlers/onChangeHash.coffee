module.exports = (cur, old) ->
  hash = location.hash

  dealListPattern = /app\/deals\/list/

  if cur?.match dealListPattern
    matches = cur.match /grouped_by=([^&]+)/
    groupingCondition = matches?[1] or 'none'

    if groupingCondition is 'industry' or not old?.match dealListPattern
      require('../handlers/onOpenDealsList')(groupingCondition)
