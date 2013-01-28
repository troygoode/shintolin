async = require 'async'
db = require '../db'
send_message = require './send_message'
send_message_settlement = require './send_message_settlement'

update_settlement = (character, settlement, cb) ->
  query =
    _id: settlement._id
  update =
    $inc:
      population: -1
    $pull:
      members:
        _id: character._id
  db.settlements.update query, update, cb

remove_invalid_leader = (character, settlement, cb) ->
  return cb() if settlement.leader?._id.toString() isnt character._id.toString()
  query =
    _id: settlement._id
  update =
    $unset:
      leader: 1
  db.settlements.update query, update, cb

remove_invalid_votes = (character, settlement, cb) ->
  query =
    _id: settlement._id
    'members.voting_for._id': character._id
  update =
    $unset:
      'members.$.voting_for': 1
  db.settlements.update query, update, cb

update_character = (character, settlement, cb) ->
  query =
    _id: character._id
  update =
    $unset:
      settlement_id: 1
      settlement_name: 1
      settlement_slug: 1
      settlement_joined: 1
      settlement_provisional: 1
  db.characters.update query, update, cb

notify_leaver = (character, settlement, cb) ->
  send_message 'left', character, character,
    settlement_id: settlement._id
    settlement_name: settlement.name
    settlement_slug: settlement.slug
  , cb

notify_members = (character, settlement, cb) ->
  send_message_settlement 'left_nearby', character, settlement, [character],
    settlement_id: settlement._id
    settlement_name: settlement.name
    settlement_slug: settlement.slug
    leader: settlement.leader?._id.toString is character._id.toString()
  , cb

module.exports = (character, settlement, cb) ->
  return cb('That settlement has been destroyed.') if settlement.destroyed
  return cb('No character passed.') unless character?
  return cb('No settlement passed.') unless settlement?
  async.series [
    (cb) ->
      update_character character, settlement, cb
    , (cb) ->
      remove_invalid_leader character, settlement, cb
    , (cb) ->
      remove_invalid_votes character, settlement, cb
    , (cb) ->
      update_settlement character, settlement, cb
    , (cb) ->
      notify_leaver character, settlement, cb
    , (cb) ->
      notify_members character, settlement, cb
  ], cb
