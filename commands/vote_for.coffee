async = require 'async'
db = require '../db'
send_message = require './send_message'

update_settlement = (settlement, voter, voting_for, cb) ->
  query =
    _id: settlement._id
    'members._id': voter._id
  if voting_for?
    update =
      $set:
        'members.$.voting_for':
          _id: voting_for._id
          name: voting_for.name
          slug: voting_for.slug
  else
    update =
      $unset:
        'members.$.voting_for': 1
  db.settlements.update query, update, false, true, cb

notify_voter = (settlement, voter, voting_for, cb) ->
  if voting_for?
    send_message 'changed_vote', voter, voter,
      voting_for_id: voting_for._id
      voting_for_name: voting_for.name
      voting_for_slug: voting_for.slug
    , cb
  else
    send_message 'changed_vote', voter, voter, {}, cb

module.exports = (settlement, voter, voting_for, cb) ->
  async.series [
    (cb) ->
      update_settlement settlement, voter, voting_for, cb
    , (cb) ->
      notify_voter settlement, voter, voting_for, cb
  ], cb
