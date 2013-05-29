_ = require 'underscore'
async = require 'async'
data = require '../data'
db = require '../db'
time = require '../time'
remove_item = require './remove_item'
charge_ap = require './charge_ap'

bound_decrease = (decrease, current, min) ->
  if current - decrease >= min
    decrease
  else
    current - min

module.exports = (character, tile, takes, cb) ->
  if takes.ap?
    return cb('Insufficient AP') unless character.ap >= takes.ap

  if takes.settlement and not tile.settlement_id?
    return cb('You must do this within a settlement.')

  if takes.building? and takes.building isnt tile.building
    return cb("You must be in the presence of a #{takes.building} to do that.")

  if takes.skill?
    skills = if _.isArray(takes.skill) then takes.skill else [takes.skill]
    unmet_skills = _.difference(skills, character.skills ? [])
    if unmet_skills.length
      return cb("You must have the skill #{unmet_skills.join(',')} to do that.")

  broken = []

  if takes.tools?
    for tool in takes.tools
      unless _.some(character.items, (i) -> i.item is tool)
        return cb("You must have a #{tool} to do that.")
      else
        tool_type = data.items[tool]
        broken.push tool if tool_type.break_odds? and Math.random() <= tool_type.break_odds

  items_to_take = []
  items_to_take.push item: key, count: value for key, value of takes.items

  for item in items_to_take
    item_in_inventory = _.find character.items, (i) ->
      i.item is item.item
    return cb("You don't have enough #{item.item} to do that.") unless item_in_inventory?.count >= item.count

  if takes.season?
    season = time().season
    seasons = if _.isArray(takes.season) then takes.season else [takes.season]
    for _season in seasons
      return next("You must wait until #{seasons.join(' or ')} before you can do that.") unless season.toLowerCase() is _season.toLowerCase()

  async.series [
    (cb) ->
      # take items from inventory
      take_item = (item, cb) ->
        remove_item character, data.items[item.item], item.count, cb
      async.each items_to_take, take_item, cb
    (cb) ->
      # charge ap
      return cb() unless takes.ap?
      charge_ap character, takes.ap, cb
    (cb) ->
      # remove building HP
      return cb() unless tile.building? and takes.tile_hp?
      building = data.buildings[tile.building]
      query =
        _id: tile._id
      update =
        $inc:
          hp: 0 - bound_decrease(takes.tile_hp, tile.hp, 0)
      db.tiles.update query, update, cb
    (cb) ->
      # remove broken tools from inventory
      return cb() unless broken.length
      break_item = (item, cb) ->
        remove_item character, data.items[item], 1, cb
      async.each broken, break_item, cb
  ], (err) ->
    return cb(err) if err?
    cb null, broken
