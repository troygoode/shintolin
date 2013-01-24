skill_tree = require '../../skill_tree'

module.exports = (app) ->
  app.post '/skills/buy/:skill_id', (req, res, next) ->
    res.redirect '/game/skills'

  app.post '/skills/sell/:skill_id', (req, res, next) ->
    res.redirect '/game/skills'

  app.get '/skills', (req, res, next) ->
    res.render 'skills',
      tree: skill_tree
      character: req.character
      can_buy: true
      maximum_skills: 17
