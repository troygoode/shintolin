async = require 'async'
db = require '../db'
settlement_name_format = /^\w+(\s\w+)*$/

module.exports = (settlement, new_values, cb) ->
  return cb('Invalid Name') unless settlement_name_format.test new_values.name
  return cb('Settlement name not long enough.') unless new_values.name.length >= 2
  return cb('Settlement name too long.') unless new_values.name.length <= 32
  return cb('Image URL too long.') if new_values.image_url?.length > 100
  return cb('Motto too long.') if new_values.motto?.length > 100
  return cb('Leader Title too long.') if new_values.leader_title?.length > 20
  return cb('Website URL too long.') if new_values.website_url?.length > 100

  async.series [
    (cb) ->
      query =
        _id: settlement._id
      update =
        $set:
          description: new_values.description ? ''
          name: new_values.name
          image_url: new_values.image_url ? ''
          motto: new_values.motto ? ''
          leader_title: new_values.leader_title ? ''
          website_url: new_values.website_url ? ''
          open: new_values.open
      db.settlements.update query, update, cb
    , (cb) ->
      return cb() if settlement.name is new_values.name
      # update cached version of settlement name on characters
      query =
        settlement_id: settlement._id
      update =
        $set:
          settlement_name: new_values.name
      db.characters.update query, update, false, true, cb
    , (cb) ->
      return cb() if settlement.name is new_values.name
      # update cached version of settlement name on tiles
      query =
        settlement_id: settlement._id
      update =
        $set:
          settlement_name: new_values.name
      db.tiles.update query, update, false, true, cb
  ], cb
