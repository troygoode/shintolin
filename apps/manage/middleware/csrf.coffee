module.exports = (req, res, next) ->
  req.csrfToken (err, token) ->
    return next(err) if err?
    res.locals.csrf = token
    next()
