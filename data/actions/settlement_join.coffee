BPromise = require 'bluebird'
get_settlement = BPromise.promisify(require '../../queries/get_settlement')
join_settlement = BPromise.promisify(require '../../commands/join_settlement')

module.exports = (character, tile) ->
  return false if character.settlement_id?
  return false if character.hp is 0

  category: 'building'
  ap: 25

  execute: ->
    BPromise.resolve()
      .then ->
        throw 'You already belong to a settlement.' if character.settlement_id?
        throw 'Invalid Settlement' unless tile.settlement_id?
        get_settlement tile.settlement_id.toString()
      .then (settlement) ->
        throw 'Invalid Settlement' unless settlement?
        join_settlement character, settlement
