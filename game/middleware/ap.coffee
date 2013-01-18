commands = require '../../commands'

module.exports = (cost) ->
  (req, res, next) ->
    return next('Insufficient AP') unless req.character.ap >= cost
    commands.charge_ap req.character, cost, (err) ->
      next err
