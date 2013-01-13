module.exports = (app) ->
  app.get '/rankings', (req, res, next) ->
    #TODO: implement metrics
    res.render 'rankings'
