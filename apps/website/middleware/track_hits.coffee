Bluebird = require 'bluebird'
db = require '../../../db'

module.exports = (req, res, next) ->
  if req.session?.possessor?
    return next()

  if not req.session?.character?
    return next()

  now = new Date()
  date_string = now.toDateString()
  _id = "#{req.ip}_#{date_string}".replace /\W/g, '_'

  Bluebird.resolve()
    .then ->
      db.hits().findOne(_id: _id)

    .then (record) ->
      if record?
        query =
          _id: _id
        update =
          $set:
            last_access: now
          $inc:
            hits: 1
        db.hits().updateOne query, update
      else
        doc =
          _id: _id
          ip: req.ip
          date: date_string
          last_access: now
          character: req.session.character
          hits: 1
        db.hits().insertOne doc

    .then ->
      next()
