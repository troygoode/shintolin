config = require '../../config'
commands = require '../../commands'
data = require '../../data'
skill_tree = require '../../skill_tree'

module.exports = (app) ->
  app.post '/skills/buy/:skill_id', (req, res, next) ->
    skill = data.skills[req.param('skill_id')]
    return next('Invalid Skill') unless skill?
    return next('You have reached the current maximum level; you must unlearn some skills before you can learn any more.') if req.character.level >= config.maximum_level
    return next('You are not able to buy that skill; either you already have it, or lack the required prerequisites.') unless req.character.skills.indexOf(skill.id) is -1
    commands.buy_skill req.character, skill, (err) ->
      return next(err) if err?
      res.redirect '/game/skills'

  app.post '/skills/sell/:skill_id', (req, res, next) ->
    skill = data.skills[req.param('skill_id')]
    return next('Invalid Skill') unless skill?
    return next('You don\'t have that skill.') if req.character.skills.indexOf(skill.id) is -1
    commands.sell_skill req.character, skill, (err) ->
      return next(err) if err?
      res.redirect '/game/skills'

  app.get '/skills', (req, res, next) ->
    res.render 'skills',
      tree: skill_tree
      character: req.character
      can_buy: true
      maximum_skills: config.maximum_level - 1
