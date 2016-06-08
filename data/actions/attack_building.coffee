_ = require 'underscore'
Bluebird = require 'bluebird'
{items, buildings} = require '../'
tiles_in_circle_around = Bluebird.promisify(require('../../queries').tiles_in_circle_around)
damage_building = Bluebird.promisify(require('../../commands').damage_building)

big_buildings = []
for key, b of buildings
  if b.interior?
    big_buildings.push b.id

buildings_to_destroy_first = (target) ->
  return 0 unless target.hq # only mess with this if the attacked building is the Totem Pole
  Bluebird.resolve()
    .then ->
      tiles_in_circle_around target, 5
    .then (tiles) ->
      matching = tiles.filter (t) ->
        return false unless t.building?
        return false if t.hq
        return false if t._id.toString() is target._id.toString()

        b = buildings[t.building]
        return false if b.invulnerable

        big_buildings.indexOf(t.building) isnt -1
      matching.length

by_efficacy = (character, tile) ->
  (ic) ->
    item = items[ic.item]
    return unless _.contains item?.tags, 'weapon'
    return unless item.accuracy? and item.damage?
    acc = item.accuracy character, null, tile
    dmg = item.damage character, null, tile
    (acc * dmg) * -1

by_name = (ic) ->
  item = items[ic.item]
  item.name

module.exports = (character, tile) ->
  return false unless tile?.building?
  return false unless character.z is 0

  weapons = {}
  citems = character.items.slice(0)
  citems.unshift item: 'fist', count: 1
  for ic in _.chain(citems).sortBy(by_name).sortBy(by_efficacy(character, tile)).value()
    item = items[ic.item]
    if _.contains(item?.tags, 'weapon') and _.contains(item.tags, 'attack:building')
      acc = item.accuracy character, null, tile
      dmg = item.damage character, null, tile
      weapons[item.id] = "#{item.name} (#{Math.floor(acc * 100)}%, #{dmg} DMG)"
  return false if _.isEmpty(weapons)

  category: 'building'
  ap: 5
  weapons: weapons

  execute: (body) ->
    item = items[body.item]

    Bluebird.resolve()
      .then ->
        throw 'Invalid Weapon' unless _.contains item?.tags, 'weapon'
        inventory_item = _.find character.items, (i) ->
          i.item is item.id
        throw "You don\'t have a #{item.name}." unless inventory_item? or item.intrinsic
        throw 'That weapon cannot damage a building.' unless _.contains item.tags, 'attack:building'

      .then ->
        return unless tile.settlement_id?
        s_id = tile.settlement_id.toString()
        for p in tile.people
          if p.hp > 0 and p.settlement_id? and not p.settlement_provisional and p.settlement_id.toString() is s_id
            throw "This building is being protected by members of the settlement!"

        ###
        .then ->
          buildings_to_destroy_first(tile)
          .then (number_to_destroy) ->
            throw "There are still #{number_to_destroy} large buildings in the vicinity. You must destroy all the buildings in the area before you can attack the #{tile.building}." if number_to_destroy > 0
        ###

      .then ->
        damage_building character, tile, item
