module.exports = (req, res, next) ->
  res.locals.csrf = req.session._csrf
  next()
