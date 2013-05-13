db = require '../../../db'
mw = require '../middleware'

#TODO: secure

module.exports = (app) ->

  app.get '/debug/replenish-ap', (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        ap: 100
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.get '/debug/replenish-hp', (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        hp: 50
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game'
