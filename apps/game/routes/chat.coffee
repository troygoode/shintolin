moment = require 'moment'
BPromise = require 'bluebird'
say = BPromise.promisify(require '../../../commands/say')
latest_chat_messages = BPromise.promisify(require '../../../queries/latest_chat_messages')
get_character_by_name = BPromise.promisify(require '../../../queries/get_character_by_name')
mw = require '../middleware'

PAGE_SIZE = 25
REGEX = /^(\/(\w+)\s)?(.+)$/
REGEX_WHISPER = /^(\@(\w+)\s)(.+)$/
SHORTCUTS =
  w: 'whisper'
  t: 'whisper'
  tell: 'whisper'
  me: 'emote'

is_same_tile = (character1, character2) ->
  character1.x is character2.x and character1.y is character2.y and character1.z is character2.z

module.exports = (app) ->
  app.get '/chat', mw.chat_locals, (req, res, next) ->
    page = parseInt(req.query.page ? 1)
    return next('Invalid Page') unless page >= 1
    BPromise.resolve()
      .then ->
        latest_chat_messages req.character, (page - 1) * PAGE_SIZE, PAGE_SIZE
      .then (messages) ->
        res.locals.moment = moment
        res.render 'chat',
          character: req.character
          messages: messages
          page: page
          page_size: PAGE_SIZE
          origin: 'history'
          error: req.query.error
      .catch next

  app.post '/chat', (req, res, next) ->
    [..., volume, text] = (req.body.text ? '').match REGEX
    volume ?= 'say'
    volume = SHORTCUTS[volume] ? volume

    BPromise.resolve()
      .then ->
        return undefined unless volume is 'whisper'
        [..., target_name, text] = text.match(REGEX_WHISPER) ? []
        throw 'Invalid Whisper' unless target_name?.length
        get_character_by_name target_name
      .then (target) ->
        if target?
          throw 'That player is too far away.' unless is_same_tile(target, req.character) # found elsewhere
        else if volume is 'whisper'
          throw 'No such player.' # no target found

        return unless text?.length
        text = text.trim()
        say req.character, target, text, volume
      .then ->
        if req.body.origin is 'history'
          res.redirect '/game/chat'
        else
          res.redirect '/game'
      .catch next
