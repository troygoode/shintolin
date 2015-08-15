_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
craft = Bluebird.promisify(require('../../commands').craft)
send_message = Bluebird.promisify(require('../../commands').send_message)
QUARRY_CHANCE = .5
AP = 4

module.exports = (character, tile) ->
  return false unless _.contains(character.skills, 'quarrying')

  tool = _.find character.items, (i) ->
    _.contains items[i.item].tags, 'quarry'
  item = items[tool?.item]

  category: 'location'
  ap: AP
  charge_ap: false # done via recipe instead

  execute: ->
    Bluebird.resolve()
      .then ->
        throw 'You need a pick to quarry here.' unless item?

        recipe =
          takes:
            tools: [item.id]
            skill: 'quarrying'
            ap: AP
        if Math.random() < QUARRY_CHANCE
          recipe.gives =
            items:
              boulder: 1
            xp:
              crafter: 3
        craft character, tile, recipe, null

      .then ([recipe, broken_items]) ->
        send_message 'quarry', character, character,
          success: recipe.gives?
          tool: item.id
          broken: broken_items?.length > 0
