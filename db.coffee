async = require 'async'
Bluebird = require 'bluebird'
MongoClient = require 'mongodb'
config = require './config'

_client = null
_db = null # new Mongolian config.mongo_uri
indexes = []

dbName = ->
  name = config.mongo_uri
  name = name.substring(name.lastIndexOf('/') + 1)
  if (name.includes '?')
    name = name.substring(0, name.indexOf('?'))
  name

connect = ->
  console.log "connecting to #{config.mongo_uri}"
  new Bluebird (resolve, reject) ->
    MongoClient.connect config.mongo_uri, { useNewUrlParser: true, useUnifiedTopology: true }, (err, client) ->
      if err?
        reject err
      else
        _db_name = config.mongo_uri.substring(config.mongo_uri.lastIndexOf('/') + 1)
        _client = client
        _db = client.db(dbName())
        resolve _db

module.exports =

  connect2: ->
    new Bluebird (resolve, reject) ->
      return {db: _db, client: _client} if _db?
      connect().then(()-> resolve(db: _db, client: _client)).catch(reject)

  connect: ->
    new Bluebird (resolve, reject) ->
      return _db if _db?
      connect().then(()-> resolve(_db)).catch(reject)

  dbName: dbName

  ObjectId: (id) ->
    if id? and typeof(id) is 'string'
      new MongoClient.ObjectId(id)
    else if id?
      id
    else
      new MongoClient.ObjectId()

  characters: -> _db.collection 'characters'
  chat_messages: -> _db.collection 'chat_messages'
  tiles: -> _db.collection 'tiles'
  settlements: -> _db.collection 'settlements'
  hits: -> _db.collection 'hits'

  register_index: (collection, index, options) ->
    return
    ###
    indexes.push
      collection: collection
      index: index
      options: options
    ###
  ensure_indexes: (cb) ->
    cb()
    ###
    async.forEach indexes
      , (index, cb) ->
        index.collection.ensureIndex index.index, index.options, cb
      , (err) ->
        cb err, indexes
    ###
