commands = require '../../commands'

module.exports = (cost) ->
  (req, res, next) ->
    commands.charge_ap req.character, cost, (err) ->
      next err
