debug = require('debug')('shintolin:middleware')
db = require '../../../db'
MAX_HITS = 1500

module.exports = (req, res, next) ->
  debug 'track_hits enter'
  now = new Date()
  date_string = now.toDateString()
  _id = "#{req.ip}_#{date_string}".replace /\W/g, '_'

  db.hits().findOne _id: _id, (err, record) ->
    return next(err) if err?

    if record?.hits > MAX_HITS
      res.send('You have exceeded your IP limit for the day. Please wait until tomorrow to play again.')
    else
      debug 'track_hits yield'
      next() # don't block for below update

    if record?
      query =
        _id: _id
      update =
        $set:
          last_access: now
        $inc:
          hits: 1
      db.hits().updateOne query, update, true, (err) ->
        console.log("ERROR in track_hits middleware:", err) if err?
        debug 'track_hits end'
    else
      doc =
        _id: _id
        ip: req.ip
        date: date_string
        last_access: now
        character: req.session.character
        hits: 1
      db.hits().insertOne doc, (err) ->
        console.log("ERROR in track_hits middleware:", err) if err?
        debug 'track_hits ends'
