module.exports = (app) ->
  app.get '/forums', (req, res, next) ->
    res.render 'moot'
