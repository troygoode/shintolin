time = require '../../time'

module.exports =
  id: 'field'
  style: 'field_s'

  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are standing in a ploughed field. It looks like something was recently planted here, though nothing has grown yet.'
      when 'Summer'
        'You are standing in a field. Wheat is growing here, green and unripe.'
      when 'Autumn'
        'You are standing in a field. Ripe, golden wheat stalks are waving in the breeze.'
      when 'Winter'
        'It looks like there was a crop growing in this field, but it was left unharvested and has rotted.'
