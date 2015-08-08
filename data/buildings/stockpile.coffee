module.exports =
  name: 'Stockpile'
  size: 'tiny'
  hp: 8
  actions: ['take', 'give', 'write']
  tags: ['visible_inventory', 'inventory_doesnt_decay']

  build: (character, tile) ->
    takes:
      ap: 10
      skill: 'trailblazing'
      items:
        stone: 8
    gives:
      xp:
        wanderer: 10

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 5
      skill: 'trailblazing'
      items:
        stone: 1
    gives:
      tile_hp: 1
      xp:
        wanderer: 1

  text:
    built: 'You stake out a stockpile on the ground.'
