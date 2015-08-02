_ = require 'underscore'
Bluebird = require 'bluebird'
moment = require 'moment'
commands = require '../../../commands'
data = require '../../../data'
queries = require '../../../queries'
days_until_full_status = 1

get_settlement_by_slug = Bluebird.promisify queries.get_settlement_by_slug
get_character = Bluebird.promisify queries.get_character
vote_for = Bluebird.promisify commands.vote_for
evict = Bluebird.promisify commands.evict
promote = Bluebird.promisify commands.promote

count_votes = (settlement, member) ->
  votes = 0
  for m in settlement.members
    votes++ if m.voting_for?._id.toString() is member._id.toString()
  votes

visit_member = (settlement, member) ->
  yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - days_until_full_status)

  leader = settlement.leader? and settlement.leader._id.toString() is member._id.toString()

  _id: member._id
  name: member.name
  slug: member.slug
  joined: member.joined
  provisional: member.provisional
  voting_for: member.voting_for
  leader: leader
  votes: count_votes settlement, member

is_member = (settlement, character_id) ->
  match = _.find settlement.members ? [], (member) ->
    member._id.toString() is character_id
  !!match

is_provisional = (settlement, character_id) ->
  match = _.find settlement.members ? [], (member) ->
    member._id.toString() is character_id
  match && match.provisional

load_target = (req) ->
  () ->
    Bluebird.resolve()
      .then ->
        Bluebird.all [
          get_settlement_by_slug req.params.settlement_slug
          get_character req.session.character
          get_character req.body.target_id
        ]
      .tap ([settlement, you, target]) ->
        throw 'Invalid Settlement' unless settlement?
        throw 'Unauthorized' unless you? and you.settlement_id?.toString() is settlement._id.toString()
        throw 'Unauthorized' if you.settlement_provisional
        throw 'Invalid Target' unless target? and target.settlement_id?.toString() is settlement._id.toString()

module.exports = (app) ->

  app.get '/settlements/:settlement_slug', (req, res, next) ->
    queries.get_settlement_by_slug req.params.settlement_slug, (err, settlement) ->
      return next(err) if err?
      return next() unless settlement?
      res.render 'settlement',
        moment: moment
        is_leader: req.session.character? and settlement.leader? and req.session.character is settlement.leader._id.toString()
        is_member: is_member settlement, req.session.character
        is_provisional: is_provisional settlement, req.session.character
        your_vote: _.find(settlement.members, (m) ->
          req.session.character? and m._id.toString() is req.session.character
        )?.voting_for
        settlement: settlement
        region: if settlement.region?.length then data.regions[settlement.region] else null
        members: settlement.members.map (m) -> visit_member settlement, m
        editable: req.session.character? and settlement.leader? and req.session.character is settlement.leader._id.toString()

  app.post '/settlements/:settlement_slug', (req, res, next) ->
    queries.get_settlement_by_slug req.params.settlement_slug, (err, settlement) ->
      return next(err) if err?
      return next() unless settlement?
      leader = req.session.character? and settlement.leader? and req.session.character is settlement.leader._id.toString()
      return next('Unauthorized') unless leader or req.session?.developer
      update =
        description: req.body.description
        name: req.body.name
        image_url: req.body.image_url
        motto: req.body.motto
        leader_title: req.body.leader_title
        member_title: req.body.member_title
        provisional_title: req.body.provisional_title
        website_url: req.body.website_url
        open: req.body.open is 'true'
      commands.update_settlement_profile settlement, update, (err) ->
        return next(err) if err?
        res.redirect "/settlements/#{settlement.slug}"

  app.post '/settlements/:settlement_slug/vote', (req, res, next) ->
    Bluebird.resolve()
      .then load_target(req)
      .tap ([settlement, you, target]) ->
        throw 'Invalid Target' if target.settlement_provisional
        vote_for settlement, you, target
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next

  app.post '/settlements/:settlement_slug/evict', (req, res, next) ->
    Bluebird.resolve()
      .then load_target(req)
      .tap ([settlement, you, target]) ->
        throw 'Unauthorized' unless settlement.leader? and settlement.leader._id.toString() is you._id.toString()
        throw 'Invalid Target' unless target.settlement_provisional
        evict target
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next

  app.post '/settlements/:settlement_slug/promote', (req, res, next) ->
    Bluebird.resolve()
      .then load_target(req)
      .tap ([settlement, you, target]) ->
        throw 'Unauthorized' unless settlement.leader? and settlement.leader._id.toString() is you._id.toString()
        throw 'Invalid Target' unless target.settlement_provisional
        promote target
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next
