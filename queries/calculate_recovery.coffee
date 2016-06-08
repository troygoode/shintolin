Bluebird = require 'bluebird'
_ = require 'underscore'

config = require '../config'
data = require '../data'
hunger_debuff = require './calculate_hunger_debuff'
active_or_healthy_players = Bluebird.promisify(require './active_or_healthy_players')

MINIMUM_RECOVERY = 1

module.exports = (character, tile) ->
  Bluebird.resolve()

    .then ->
      active_or_healthy_players()

    .then (visible) ->
      visible = _.pluck(visible, '_id').map((id) -> id.toString())
      occupants = (tile?.people ? []).filter (p) ->
        _.contains(visible, p._id.toString()) and
        not p.creature?
      (occupants ? []).length

    .then (occupantCount) ->
      recovery = config.ap_per_hour

      if character.hp <= 0
        recovery = MINIMUM_RECOVERY
      else
        # hunger debuff
        recovery += hunger_debuff character, tile

      # terrain bonus
      if tile?
        terrain = data.terrains[tile.terrain]
        if terrain.recovery?
          recovery += terrain.recovery(character, tile)
      else
        terrain = data.terrains[config.default_terrain]
        if terrain.recovery?
          recovery += terrain.recovery(character, tile)

      # building bonus
      if tile?.building?
        building = data.buildings[tile.building]
        if building.recovery? and (not building.max_occupancy? or occupantCount <= building.max_occupancy)
          recovery += building.recovery(character, tile)

      recovery = MINIMUM_RECOVERY if recovery < MINIMUM_RECOVERY #minimum recovery
      recovery
