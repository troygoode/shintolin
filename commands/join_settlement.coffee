async = require 'async'
db = require '../db'
send_message = require './send_message'
send_message_settlement = require './send_message_settlement'

update_settlement = (character, settlement, now, cb) ->
  query =
    _id: settlement._id
  update =
    $inc:
      population: 1
    $push:
      members:
        _id: character._id
        name: character.name
        slug: character.slug
        joined: now
  db.settlements.update query, update, cb

update_character = (character, settlement, now, cb) ->
  query =
    _id: character._id
  update =
    $set:
      settlement_id: settlement._id
      settlement_name: settlement.name
      settlement_slug: settlement.slug
      settlement_joined: now
  db.characters.update query, update, cb

defacto_leader = (character, settlement, cb) ->
  return cb() if settlement.population > 0
  query =
    _id: settlement._id
  update =
    $set:
      leader:
        _id: character._id
        name: character.name
        slug: character.slug
  db.settlements.update query, update, cb

notify_joiner = (character, settlement, cb) ->
  send_message 'join', character, character,
    settlement_id: settlement._id
    settlement_name: settlement.name
    settlement_slug: settlement.slug
  , cb

notify_members = (character, settlement, cb) ->
  send_message_settlement 'join_nearby', character, settlement, [character],
    settlement_id: settlement._id
    settlement_name: settlement.name
    settlement_slug: settlement.slug
  , cb

module.exports = (character, settlement, cb) ->
  return cb('No character passed.') unless character?
  return cb('No settlement passed.') unless settlement?
  now = new Date()
  async.series [
    (cb) ->
      update_character character, settlement, now, cb
    , (cb) ->
      update_settlement character, settlement, now, cb
    , (cb) ->
      defacto_leader character, settlement, cb
    , (cb) ->
      notify_joiner character, settlement, cb
    , (cb) ->
      notify_members character, settlement, cb
  ], cb
