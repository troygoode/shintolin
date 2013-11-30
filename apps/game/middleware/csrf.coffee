debug = require('debug')('shintolin:middleware')

module.exports = (req, res, next) ->
  res.locals.csrf = req.csrfToken()
  next()
