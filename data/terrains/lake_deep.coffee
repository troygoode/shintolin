_ = require 'underscore'
time = require '../../time'

module.exports =
  id: 'lake_deep'
  style: 'dwater'

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are swimming through the deep water of a lake.'
      when 'Summer'
        'You are swimming through the deep water of a lake. The cool water brings relief from the heat of the sun.'
      when 'Autumn'
        'You are swimming through the deep water of a lake.'
      when 'Winter'
        'You are swimming through the deep water of a lake. The cold water chills you to the bone.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      3
    else
      null
