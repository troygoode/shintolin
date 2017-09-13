BPromise = require 'bluebird'
moment = require 'moment'

get_settlement = BPromise.promisify(require '../../queries/get_settlement')
get_character = BPromise.promisify(require '../../queries/get_character')
dazed_players_in_settlement = BPromise.promisify(require '../../queries/dazed_players_in_settlement')
remove_from_settlement = BPromise.promisify(require '../../commands/remove_from_settlement')
send_message_settlement = BPromise.promisify(require '../../commands/send_message_settlement')

module.exports = (character, tile) ->
  return false unless character.settlement_id? and character.settlement_id.toString() is tile.settlement_id.toString()
  return false if character.hp is 0

  BPromise.props(
    settlement: get_settlement tile.settlement_id
    members: dazed_players_in_settlement tile.settlement_id
  ).then ({ settlement, members }) ->

    return false unless settlement.leader?._id? and settlement.leader._id.toString() is character._id.toString()
    deadline = moment().subtract(5, 'days')._d

    category: 'building'
    ap: 25
    people: members.map (m) =>
      if m.banned
        m.name = "#{m.name} [BANNED]"
      else if m.last_action < deadline
        m.name = "#{m.name} [Inactive]"
      m

    execute: (body) ->
      BPromise.resolve()
        .then ->
          get_character body.target
        .tap (target) ->
          msg =
            target_id: target._id
            target_slug: target.slug
            target_name: target.name
          send_message_settlement 'kicked_from_settlement', character, settlement, [], msg
        .tap (target) ->
          remove_from_settlement target
