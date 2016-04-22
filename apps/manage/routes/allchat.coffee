Bluebird = require 'bluebird'

db = require '../../../db'

PAGE_SIZE = 50

allchat = ->
  db.chat_messages().aggregate([
    { $match: { type: 'social' } },
    { $group: {
        _id: '$tx',
        sender_id: {$first: '$sender_id'},
        sender_name: {$first: '$sender_name'},
        sent: {$min: '$sent'},
        text: {$first: '$text'},
        volume: {$first: '$volume'},
        recipients: {$sum: 1}
    } },
    { $sort: { sent: -1 } }
  ], {
    allowDiskUse: true
  })

module.exports = (app) ->

  app.get '/allchat', (req, res, err) ->
    page = parseInt(req.query?.page ? 1)

    Bluebird.resolve()
      .then ->
        allchat().skip((page - 1) * PAGE_SIZE).limit(PAGE_SIZE).toArray()

      .then (msgs) ->
        res.render 'allchat',
          messages: msgs
          page: page
          page_size: PAGE_SIZE

      .catch (err) ->
        next err
