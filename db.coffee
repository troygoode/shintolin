async = require 'async'
Mongolian = require 'mongolian'
config = require './config'

db = new Mongolian config.mongo_uri
indexes = []

module.exports =
  ObjectId: Mongolian.ObjectId

  characters: db.collection 'characters'

  register_index: (collection, index, options) ->
    indexes.push
      collection: collection
      index: index
      options: options
  ensure_indexes: (cb) ->
    async.forEach indexes
      , (index, cb) ->
        index.collection.ensureIndex index.index, index.options, cb
      , (err) ->
        cb err, indexes
