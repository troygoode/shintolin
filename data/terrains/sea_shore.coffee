time = require '../../time'

module.exports =
  style: 'beach'
  block_spawning: true
  no_season: true

  tags: ['wetland']
  buildable: ['tiny']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are walking along a white sandy beach. Sunlight dapples on the water.'
      when 'Summer'
        'You are walking along a white sandy beach. A cool breeze blows from the water, bringing relief from the hot sun.'
      when 'Autumn'
        'You are walking along a white sandy beach.'
      when 'Winter'
        'You are walking along a white sandy beach.'
