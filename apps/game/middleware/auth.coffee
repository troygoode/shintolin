module.exports = (req, res, next) ->
  res.locals.is_developer = req.session?.developer is true
  return next() if req.session.character?.length
  res.redirect '/?msg=auth'
