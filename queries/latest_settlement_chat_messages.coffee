db = require '../db'

db.register_index db.chat_messages,
  sent: -1
  volume: 1
  settlement_id: 1

module.exports = (settlement, skip, limit, cb) ->
  query =
    volume: 'settlement'
    settlement_id: settlement._id
    $where: 'this.sender_id.toString() === this.recipient_id.toString()'
  db.chat_messages.find(query).sort({ sent: -1 }).skip(skip).limit(limit).toArray cb
