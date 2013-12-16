module.exports = (app) ->
  app.get '/', (req, res) ->
    res.redirect '/manage/map'
