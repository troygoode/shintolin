_ = require 'underscore'
async = require 'async'
db = require '../db'
queries = require '../queries'
send_message_all = require './send_message_all'

module.exports = (type, sender, settlement, blacklist = [], message = {}, cb) ->
  send_message_all type, sender, settlement.members, blacklist, message, cb
