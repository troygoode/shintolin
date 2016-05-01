_ = require 'underscore'
Bluebird = require 'bluebird'
{items, skills} = require '../'
craft = require '../../commands/craft'
send_message = Bluebird.promisify(require('../../commands').send_message)
can_take = require '../../queries/can_take'
ACTION = 'craft'

visit_recipe = (recipe, action, character, tile) ->
  io = recipe[action] character, tile
  takes_items = []
  Bluebird.resolve()
    .then ->
      return {craftable: false, hard: true} if io?.takes?.developer

      # visit skills
      for skill_key in character.skills ? []
        if skills[skill_key]?.actions?.craft
          skills[skill_key].actions.craft character, tile, io.gives, io.takes

      takes_items.push {item: key, count: value} for key, value of io.takes.items
      can_take(character, tile, io.takes)
        .catch (err) ->
          return {craftable: false, hard: true} if err?.hard
          craftable: false

    .then (can_take_response) ->
      return false if can_take_response?.hard is true
      retval =
        id: recipe.id
        name: recipe.name
        gives: io.gives
        takes: io.takes
        ap: io.takes.ap
        items: takes_items
        tools: io.takes.tools
        hp: io.gives?.tile_hp
        craftable: can_take_response?.craftable ? true
      retval[action] = recipe[action]
      [recipe.id, retval]

module.exports = (character, tile) ->
  Bluebird.resolve()
    .then ->
      _.pairs(items)

    .map ([key, recipe]) ->
      if recipe.craft?
        visit_recipe recipe, ACTION, character, tile
      else
        false

    .then (pairs) ->
      _.object(pairs.filter((p) -> p? is true and p isnt false))

    .then (recipes) ->
      category: 'self'
      charge_ap: false # done via recipe instead
      recipes: recipes

      execute: (body) ->
        recipe = recipes[body.recipe]
        Bluebird.resolve()

          .then ->
            throw 'Invalid Recipe' unless recipe?[ACTION]?
            craft character, tile, recipe

          .then ({recipe, broken_items}) ->
            send_message 'craft', character, character,
              recipe: recipe.name
              gives: recipe.gives
              takes: recipe.takes
              broken: broken_items
