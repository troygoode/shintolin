_ = require 'underscore'
data = require '../data'

weighted_table = (table) ->
  result = {}
  total = 0
  for key, odds of table ? {}
    total += odds
    result[key] = total
  result

get_item = (table) ->
  r = Math.random()
  for item_type, odds of table ? {}
    return item_type if r < odds
  return null

total_odds = (table) ->
  odds = []
  odds.push o for key, o of table ? {}
  if odds.length
    _.max odds
  else
    0

module.exports = (search_odds, cb) ->
  weighted = weighted_table search_odds
  total = total_odds weighted
  return cb('Total odds over 100%!') if total > 1
  cb null, get_item(weighted), total
