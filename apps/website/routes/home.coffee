_ = require 'underscore'
async = require 'async'
marked = require 'marked'
glob = require 'glob'
fs = require 'fs'
moment = require 'moment'
updates = []
queries = require '../../../queries'

glob "#{__dirname}/../../../data/release-notes/**/*.md", (err, files) ->
  throw err if err?
  files = files.reverse()
  for path in files
    file_content = fs.readFileSync path, 'utf-8'

    matches = path.match /(\d{4})\-(\d{2})-(\d{2})/
    date = new Date(matches[1], parseInt(matches[2]) - 1, parseInt(matches[3]))

    updates.push
      date: date
      html: marked(file_content)

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    async.parallel [
      (cb) ->
        queries.squares cb
      , (cb) ->
        queries.all_settlements cb
      , (cb) ->
        queries.rankings.younguns cb
      , (cb) ->
        queries.active_characters cb
    ], (err, [square_count, settlements, younguns, active_character_count]) ->
      return next(err) if err?
      active_settlements = settlements.filter (s) ->
        not s.destroyed?
      res.render 'home',
        message: req.query.msg
        square_count: square_count
        settlement_count: active_settlements.length
        settlements: active_settlements.filter (s) ->
          s.open
        younguns: younguns
        server_time: new Date()
        latest_release_note: updates[0]
        moment: moment
        active_character_count: active_character_count

  app.get '/updates', (req, res, next) ->
    res.render 'updates',
      updates: updates
      moment: moment
