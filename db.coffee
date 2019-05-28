async = require 'async'
Bluebird = require 'bluebird'
MongoClient = require 'mongodb'
config = require './config'

db = null # new Mongolian config.mongo_uri
indexes = []

module.exports =
  connect: ->
    console.log "connecting to #{config.mongo_uri}"
    new Bluebird (resolve, reject) ->
      MongoClient.connect config.mongo_uri, { useNewUrlParser: true }, (err, client) ->
        if err?
          reject err
        else
          db_name = config.mongo_uri.substring(config.mongo_uri.lastIndexOf('/') + 1)
          db = client.db(db_name)
          resolve db

  ObjectId: (id) ->
    if id? and typeof(id) is 'string'
      new MongoClient.ObjectId(id)
    else if id?
      id
    else
      new MongoClient.ObjectId()

  characters: -> db.collection 'characters'
  chat_messages: -> db.collection 'chat_messages'
  tiles: -> db.collection 'tiles'
  settlements: -> db.collection 'settlements'
  hits: -> db.collection 'hits'

  register_index: (collection, index, options) ->
    return
    ###
    indexes.push
      collection: collection
      index: index
      options: options
    ###
  ensure_indexes: (cb) ->
    return
    ###
    async.forEach indexes
      , (index, cb) ->
        index.collection.ensureIndex index.index, index.options, cb
      , (err) ->
        cb err, indexes
    ###
