queries = require '../../../queries'

module.exports = (req, res, next) ->
  queries.get_character req.session.character, (err, character) ->
    return next(err) if err?
    return res.redirect('/logout') unless character? #probably a db reset
    req.character = character
    next()
