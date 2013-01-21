moment = require 'moment'
commands = require '../../commands'
queries = require '../../queries'
mw = require '../middleware'
page_size = 25

module.exports = (app) ->
  app.get '/chat', (req, res, next) ->
    page = parseInt(req.param('page') ? 0)
    return next('Invalid Page') unless page >= 0
    queries.latest_chat_messages req.character, page * page_size, page_size, (err, messages) ->
      return next(err) if err?
      res.locals.moment = moment
      res.render 'chat',
        messages: messages
        page: page
        page_size: page_size
        suppress_more_link: true

  app.post '/chat', mw.ap(1), (req, res, next) ->
    commands.say req.character, req.body.text, (err) ->
      return next(err) if err?
      res.redirect '/game'
