async = require 'async'
remove_item = require './remove_item'
charge_ap = require './charge_ap'
create_building = require './create_building'
xp = require './xp'
send_message = require './send_message'
send_message_nearby = require './send_message_nearby'

module.exports = (builder, tile, building, cb ) ->
  return cb('Xyzzy shenanigans') if tile.z isnt 0 # no building huts inside of huts :-)
  return cb('Invalid Building') unless building?
  return cb('There is already a building here.') if tile.building?

  takes = building.takes builder, tile
  gives = building.gives builder, tile
  return cb('Insufficient AP') unless builder.ap >= takes.ap

  broken = []

  if takes.tools?
    for tool in takes.tools
      unless _.some(builder.items, (i) -> i.item is tool)
        return cb("You must have a #{tool} to build that.")
      else
        tool_type = data.items[tool]
        broken.push tool if tool_type.break_odds? and Math.random() <= tool_type.break_odds

  terrain = data.terrains[tile.terrain]
  return cb('Nothing can be built here.') unless terrain.buildable?
  return cb('You cannot build that here.') unless terrain.buildable.indexOf(building.size) isnt -1

  items_to_take = []
  items_to_take.push item: key, count: value for key, value of takes.items

  async.series [
    (cb) ->
      # take items from inventory
      take_item = (item, cb) ->
        remove_item builder, data.items[item.item], item.count, cb
      async.forEach items_to_take, take_item, cb
    , (cb) ->
      # charge ap
      charge_ap builder, takes.ap, cb
    , (cb) ->
      # create building
      create_building tile, building, cb
    , (cb) ->
      # remove broken tools from inventory
      return cb() unless broken.length
      break_item = (item, cb) ->
        remove_item builder, data.items[item], 1, cb
      async.forEach broken, break_item, cb
    , (cb) ->
      # grant xp
      xp builder, gives.xp.wanderer ? 0, gives.xp.herbalist ? 0, gives.xp.crafter ? 0, gives.xp.warrior ? 0, cb
    , (cb) ->
      # notify user of success
      send_message 'built', builder, builder,
        building: building.id
        broken: broken
      , cb
    , (cb) ->
      # notify others of success
      send_message_nearby 'built_nearby', builder, [builder],
        building: building.id
        broken: broken
      , cb
  ], cb
