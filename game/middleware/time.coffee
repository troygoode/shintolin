time = require '../../time'

module.exports = (req, res, next) ->
  req.time = time(new Date())
  next()
