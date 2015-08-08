_ = require 'underscore'
time = require '../../time'
define_loot_table = require '../../queries/loot_table_define'

module.exports =
  style: 'hill2_side'
  block_spawning: true

  tags: ['hill']
  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are on the side of a hill, at medium elevation. A light breeze is blowing.'
      when 'Summer'
        'You are on the side of a hill, at medium elevation. The hot sun shines down upon you.'
      when 'Autumn'
        'You are on the side of a hill, at medium elevation. A stiff breeze is blowing.'
      when 'Winter'
        'You are on the side of a hill, at medium elevation. A cold wind is blowing.'

  search_odds: (character, tile) ->
    define_loot_table character, tile,
      items:
        flint: .20
        stone: .10

  altitude: 2
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    mountaineer = _.contains character.skills, 'mountaineering'
    if from_altitude >= @altitude
      0
    else if mountaineer
      1
    else
      ((@altitude - from_altitude) * 2) - 1
