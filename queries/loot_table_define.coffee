_ = require 'underscore'
time = require '../time'

DEFAULT_DIMINISHING_RETURNS =
  6: .75
  12: .5
  18: null

# options.items is REQUIRED and should be defined like
# selection1: .05 #5%
# selection2: .15 #15%

modify_odds = (odds, mod) ->
  odds[key] = val * mod for key, val of odds
  odds

module.exports = (character, tile, options = {}) ->
  throw 'Invalid Loot Table' unless options?.items?

  odds = options.items

  if options.diminishing_returns isnt false
    rules = []
    rules.push(min: key, mod: val) for key, val of (options.diminishing_returns ? DEFAULT_DIMINISHING_RETURNS)
    rule = _.chain(rules).sortBy((r) -> r.min).filter((r) -> (tile.searches ? 0) >= r.min).last().value()
    if rule?
      return null if rule.mod is null
      modify_odds odds, rule.mod

  odds
