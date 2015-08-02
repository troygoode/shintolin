time = require '../../time'

module.exports =
  hidden: true
  style: ->
    switch time().season
      when 'Summer'
        'field_s'
      when 'Autumn'
        'field_a'
      else
        'field_e'

  describe: (tile) ->
    watered = if tile.watered then ' The field appears to have been freshly watered.' else ''
    switch time().season
      when 'Spring'
        'You are standing in a ploughed field. It looks like something was recently planted here, though nothing has grown yet.' + watered
      when 'Summer'
        'You are standing in a field. Wheat is growing here, green and unripe.' + watered
      when 'Autumn'
        'You are standing in a field. Ripe, golden wheat stalks are waving in the breeze.' + watered
      when 'Winter'
        'It looks like there was a crop growing in this field, but it was left unharvested and has rotted.' + watered
