module.exports =
  id: 'signpost'
  name: 'Signpost'
  size: 'tiny'
  hp: 5
  actions: ['write']

  build: (character, tile) ->
    takes:
      ap: 8
      skill: 'trailblazing'
      items:
        timber: 2
    gives:
      xp:
        wanderer: 5

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 5
      items:
        timber: 1
    gives:
      tile_hp: 5
      xp:
        wanderer: 1

  text:
    built: 'You build a signpost.'
