module.exports = (req, res, next) ->
  return next(403) unless req.session.developer
  return next() if req.session.character?.length
  res.redirect '/?msg=auth'
