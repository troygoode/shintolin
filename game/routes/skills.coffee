data = require '../../data'
skill_tree = require '../../skill_tree'

module.exports = (app) ->
  app.post '/skills/buy/:skill_id', (req, res, next) ->
    skill = data.skills[req.param('skill_id')]
    return next('Invalid Skill') unless skill?
    res.redirect '/game/skills'

  app.post '/skills/sell/:skill_id', (req, res, next) ->
    res.redirect '/game/skills'

  app.get '/skills', (req, res, next) ->
    res.render 'skills',
      tree: skill_tree
      character: req.character
      can_buy: true
      maximum_skills: 17
