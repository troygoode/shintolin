data = require '../../../data'

module.exports = (app) ->
  app.get '/inventory', (req, res, next) ->
    res.render 'inventory',
      _nav: 'inventory'
      data: data
      character: req.character
