db = require '../db'

db.register_index db.characters,
  slug: 1

module.exports = (slug, cb) ->
  return cb() unless slug?.length
  query =
    slug: slug
  db.characters.findOne query, cb
