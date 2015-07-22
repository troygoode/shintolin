time = require '../../time'

module.exports =
  style: 'dirt'

  tags: ['trail', 'open']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.'
      when 'Summer'
        'You are standing on bare dirt; the dusty ground here has seen the passage of many feet.'
      when 'Autumn'
        'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.'
      when 'Winter'
        'You are standing on bare dirt; the frozen ground here has seen the passage of many feet.'

  cost_to_enter: ->
    -.5

  grow: (tile) ->
    odds = switch time().season
      when 'Spring'
        .10
    return null unless odds > 0
    return 'forest_pine_1' if Math.random() < odds
