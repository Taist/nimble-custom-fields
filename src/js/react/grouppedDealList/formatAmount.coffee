module.exports = (amount) ->
  unless amount
    return '-'

  digits = amount.toString().split('')
  groups = []
  while digits.length
    groups.unshift digits.splice(-3).join('')
  '$ ' + groups.join()
