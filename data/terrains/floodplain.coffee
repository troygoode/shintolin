time = require '../../time'
define_loot_table = require '../../queries/loot_table_define'

module.exports =
  style: ->
    switch time().season
      when 'Spring'
        'rapids'
      else
        'flood'

  tags: ['wetland', 'open']
  actions: ['dig']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are wading through ankle-deep water; the Spring floods have come to the plains.'
      when 'Summer'
        'You are walking across a flood plain. The ground bakes beneath the sun.'
      when 'Autumn'
        'You are walking across a flood plain.'
      when 'Winter'
        'You are walking across a flood plain.'

  search_odds: (character, tile) ->
    define_loot_table character, tile,
      items:
        wheat: .15

  dig_odds: (character, tile) ->
    define_loot_table character, tile,
      items:
        clay: .40
        stone: .10
        coin_gold: .01

  cost_to_enter: (character, tile_from, tile_to) ->
    switch time().season
      when 'Spring'
        4
      else
        1
