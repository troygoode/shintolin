async = require 'async'
Bluebird = require 'bluebird'
Mongolian = require 'mongolian'
config = require './config'

db = new Mongolian config.mongo_uri
indexes = []

promisify_collection = (collection) ->
  pupdate = Bluebird.promisify collection.update, collection

  update: (query, command, options = {}) ->
    UPSERT = options.upsert ? false
    MULTI = options.multi ? false
    pupdate query, command, UPSERT, MULTI
  find: (query, options = {}) ->
    cursor = collection.find(query)
    if options.transform?
      cursor = options.transform(cursor)
    Bluebird.promisify(cursor.toArray, cursor)()

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

  promisified:
    tiles: promisify_collection(db.collection 'tiles')

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
