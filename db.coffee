async = require 'async'
Mongolian = require 'mongolian'
config = require './config'

db = new Mongolian config.mongo_uri
indexes = []

module.exports =
  ObjectId: (id) ->
    if id? and typeof(id) is 'string'
      new Mongolian.ObjectId(id)
    else if id?
      id
    else
      new Mongolian.ObjectId()

  characters: db.collection 'characters'
  chat_messages: db.collection 'chat_messages'
  tiles: db.collection 'tiles'
  settlements: db.collection 'settlements'
  hits: db.collection 'hits'

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
