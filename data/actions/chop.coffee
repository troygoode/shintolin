_ = require 'underscore'
BPromise = require 'bluebird'
{items, terrains} = require '../'
craft = BPromise.promisify(require('../../commands').craft)
send_message = BPromise.promisify(require('../../commands').send_message)
SHRINK_ODDS = .12

module.exports = (character, tile) ->
  ap = if _.contains(character.skills, 'lumberjack') then 4 else 8

  category: 'location'
  ap: ap

  execute: ->
    BPromise.resolve()
      .then ->

        tool = _.find character.items, (i) ->
          _.contains items[i.item].tags, 'chop'
        throw 'You have nothing to chop down a tree with.' unless tool?.count > 0

        item = items[tool.item]

        terrain = terrains[tile.terrain]
        new_terrain = null
        if terrain.shrink? and Math.random() < SHRINK_ODDS
          new_terrain = terrain.shrink(tile)

        BPromise.resolve()
          .then ->
            craft character, tile,
              takes:
                tools: [item.id]
                ap: ap
              gives:
                terrain: new_terrain
                items:
                  log: 1
                xp:
                  wanderer: 2
            , null

          .then (recipe, broken_items) ->
            send_message 'chop', character, character,
              tool: item.id
              broken: broken_items?.length > 0
              shrank: new_terrain?
