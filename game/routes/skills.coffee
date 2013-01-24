skill_tree = require '../../skill_tree'

module.exports = (app) ->
  app.get '/skills', (req, res, next) ->
    res.render 'skills',
      tree: skill_tree
      character: req.character
      can_buy: true
      maximum_skills: 17
