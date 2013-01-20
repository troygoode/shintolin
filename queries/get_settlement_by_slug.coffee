db = require '../db'

db.register_index db.settlements,
  slug: 1

module.exports = (slug, cb) ->
  return cb() unless slug?.length
  query =
    slug: slug
  db.settlements.findOne query, cb
