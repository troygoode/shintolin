send_message_all = require './send_message_all'

module.exports = (type, sender, settlement, blacklist = [], message = {}, cb) ->
  message.settlement_id = settlement._id
  message.settlement_name = settlement.name
  message.settlement_slug = settlement.slug
  send_message_all type, sender, settlement.members, blacklist, message, cb
