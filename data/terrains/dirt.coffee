time = require '../../time'

module.exports =
  id: 'dirt'
  style: 'dirt'
  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.'
      when 'Summer'
        'You are standing on bare dirt; the dusty ground here has seen the passage of many feet.'
      when 'Autumn'
        'You are standing on bare dirt; the muddy ground here has seen the passage of many feet.'
      when 'Winter'
        'You are standing on bare dirt; the frozen ground here has seen the passage of many feet.'
