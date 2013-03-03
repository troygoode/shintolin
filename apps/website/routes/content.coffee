module.exports = (app) ->
  for page in ['screenshot', 'faq', 'credits']
    app.get "/#{page}", (req, res) ->
      res.render page
