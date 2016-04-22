async = require 'async'
Bluebird = require 'bluebird'
MongoClient = require 'mongodb'
config = require './config'

db = null # new Mongolian config.mongo_uri
indexes = []

promisify_collection = (collection) ->

  update: (query, command, options = {}) ->
    pupdate = Bluebird.promisify db.collection(collection).update, db.collection(collection)
    UPSERT = options.upsert ? false
    MULTI = options.multi ? false
    pupdate query, command, UPSERT, MULTI
  find: (query, options = {}) ->
    db.collection(collection).find(query)
  get: (query) ->
    pget = Bluebird.promisify db.collection(collection).findOne, db.collection(collection)
    pget query

module.exports =
  connect: ->
    console.log "connecting to #{config.mongo_uri}"
    new Bluebird (resolve, reject) ->
      MongoClient.connect config.mongo_uri, (err, _db) ->
        if err?
          reject err
        else
          db = _db
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

  promisified:
    characters: -> promisify_collection('characters')
    chat_messages: -> promisify_collection('chat_messages')
    tiles: -> promisify_collection('tiles')

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
