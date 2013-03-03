module.exports = (req, res, next) ->
  return next() if req.session.character?.length
  res.redirect '/?msg=auth'
