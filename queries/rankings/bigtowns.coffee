db = require '../../db'

db.register_index db.settlements,
  population: -1

module.exports = (cb) ->
  db.settlements()
    .find({
      destroyed: {$exists: false}
    })
    .sort({
      population: -1,
      founded: 1
    })
    .limit(10)
    .toArray cb
