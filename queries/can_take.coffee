_ = require 'underscore'
Bluebird = require 'bluebird'
data = require '../data'
time = require '../time'

module.exports = (character, tile, takes) ->
  Bluebird.resolve()
    .then ->
      items_to_take = []
      broken = []

      if takes.ap?
        throw 'Insufficient AP' unless character.ap >= takes.ap

      if takes.settlement and not tile.settlement_id?
        throw 'You must do this within a settlement.'

      if takes.building? and takes.building isnt tile.building
        throw "You must be in the presence of a #{data.buildings[takes.building].name} to do that."

      if takes.skill?
        skills = if _.isArray(takes.skill) then takes.skill else [takes.skill]
        unmet_skills = _.difference(skills, character.skills ? [])
        if unmet_skills.length
          throw "You must have the skill #{unmet_skills.join(',')} to do that."

      if takes.tools?
        for tool in takes.tools
          unless _.some(character.items, (i) -> i.item is tool)
            throw "You must have a #{data.items[tool].name} to do that."
          else
            tool_type = data.items[tool]
            broken.push tool if tool_type.break_odds? and Math.random() <= tool_type.break_odds

      items_to_take.push item: key, count: value for key, value of takes.items

      for takeable in items_to_take
        item = data.items[takeable.item]
        item_in_inventory = _.find character.items, (i) ->
          i.item is item.id
        throw "You don't have enough #{item.plural} to do that." unless item_in_inventory?.count >= takeable.count

      if takes.season?
        season = time().season.toLowerCase()
        seasons = if _.isArray(takes.season) then takes.season else [takes.season]
        throw "You must wait until #{seasons.join(' or ')} before you can do that." unless seasons.indexOf(season) isnt -1

      if takes.terrain_tag?
        terrain = data.terrains[tile.terrain]
        throw 'You cannot do that on this kind of terrain.' unless _.contains(terrain.tags, takes.terrain_tag)

      items_to_take: items_to_take
      broken: broken
