_ = require 'underscore'
Bluebird = require 'bluebird'
data = require '../data'
give = require './give'
take = Bluebird.promisify(require './take')

###

EXAMPLE RECIPE:

{
  validate: function (cb) { cb(); },
  takes: {
    ap: 10,
    building: 'cottage',
    developer: true,
    items: {
      flint: 1
    },
    season: 'summer',
    settlement: true,
    skill: 'construction',
    terrain_tag: 'foo',
    tile_hp: 7,
    tools: ['stone']
  },
  gives: {
    favor: 5,
    items: {
      axe_hand: 1
    },
    terrain: 'woodland',
    tile_hp: 7,
    xp: {
      crafter: 10
    }
  }
}

###

module.exports = (character, tile, make_recipe) ->
  Bluebird.resolve()
    .then ->
      # generate recipe
      if _.isFunction make_recipe
        make_recipe(character, tile)
      else
        make_recipe

    .then (recipe) ->
      Bluebird.resolve()

        # validate
        .then ->
          throw 'No crafting requirements or results specified.' unless recipe?
          return unless recipe.validate?
          validate = Bluebird.promisify(recipe.validate)
          validate()

        # take
        .then ->
          take character, tile, recipe.takes

        # give
        .tap (broken) ->
          return unless recipe.gives?
          Bluebird.resolve(Object.keys(recipe.gives))
            .each (key) ->
              handler = give[key]
              if handler?
                handler character, tile, recipe.gives[key]

        # return
        .then (broken) ->
          recipe: recipe
          broken_items: broken
