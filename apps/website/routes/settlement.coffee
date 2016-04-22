_ = require 'underscore'
Bluebird = require 'bluebird'
moment = require 'moment'
commands = require '../../../commands'
data = require '../../../data'
queries = require '../../../queries'
days_until_full_status = 1

get_settlement_by_slug = Bluebird.promisify queries.get_settlement_by_slug
get_character = Bluebird.promisify queries.get_character
all_active_members = Bluebird.promisify queries.all_active_members
settlement_chat = Bluebird.promisify queries.latest_settlement_chat_messages
update_settlement_profile = Bluebird.promisify commands.update_settlement_profile
vote_for = Bluebird.promisify commands.vote_for
evict = Bluebird.promisify commands.evict
promote = Bluebird.promisify commands.promote
leave = Bluebird.promisify commands.leave_settlement

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

filter_inactive_members = ([settlement, active_members]) ->
  settlement.members = settlement.members.filter (m) ->
    return true if settlement.leader? and settlement.leader?._id.toString() is m._id.toString()
    _.some active_members, (am) ->
      am._id.toString() is m._id.toString()
  settlement

load_settlement = (req, options = {}) ->
  () ->
    Bluebird.resolve()
      .then ->
        promises = []
        promises.push get_settlement_by_slug req.params.settlement_slug
        promises.push get_character req.session.character
        if options.target
          promises.push get_character req.body.target_id
        Bluebird.all promises
      .tap ([settlement, you, target]) ->
        # settlement
        throw 'Invalid Settlement' unless settlement?

        # you
        throw 'Unauthorized' unless you? and you.settlement_id?.toString() is settlement._id.toString()
        unless options.allow_provisional
          throw 'Unauthorized' if you.settlement_provisional
        if options.leader_only
          throw 'Unauthorized' unless settlement.leader? and settlement.leader._id.toString() is you._id.toString()

        # target
        if options.target
          throw 'Invalid Target' unless target? and target.settlement_id?.toString() is settlement._id.toString()
        if options.provisional_targets_only
          throw 'Invalid Target' unless target.settlement_provisional
        if options.nonprovisional_targets_only
          throw 'Invalid Target' if target.settlement_provisional

module.exports = (app) ->

  app.get '/settlements/:settlement_slug', (req, res, next) ->
    find_chat_messages = (settlement, start, count) ->
      return Bluebird.resolve([]) unless req.session?.developer
      settlement_chat(settlement, 0, 10)

    Bluebird.resolve()
      .then ->
        get_settlement_by_slug(req.params.settlement_slug)
          .then (settlement) ->
            all_active_members(settlement)
              .then (members) ->
                [settlement, members]
              .then filter_inactive_members
      .then (settlement) ->
        return next() unless settlement?
        find_chat_messages(settlement, 0, 10)
          .then (chat_messages) ->
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
              messages: chat_messages
              origin: 'settlement'
      .catch next

  app.post '/settlements/:settlement_slug', (req, res, next) ->
    Bluebird.resolve()
      .then ->
        get_settlement_by_slug req.params.settlement_slug
      .then (settlement) ->
        throw 'Invalid Settlement' unless settlement?
        leader = req.session.character? and settlement.leader? and req.session.character is settlement.leader._id.toString()
        throw 'Unauthorized' unless leader or req.session?.developer
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
        update_settlement_profile(settlement, update)
          .then ->
            res.redirect "/settlements/#{settlement.slug}"
      .catch next

  app.post '/settlements/:settlement_slug/vote', (req, res, next) ->
    Bluebird.resolve()
      .then load_settlement(req, target: true, nonprovisional_targets_only: true)
      .tap ([settlement, you, target]) ->
        vote_for settlement, you, target
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next

  app.post '/settlements/:settlement_slug/evict', (req, res, next) ->
    Bluebird.resolve()
      .then load_settlement(req, target: true, leader_only: true, provisional_targets_only: true)
      .tap ([settlement, you, target]) ->
        evict target
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next

  app.post '/settlements/:settlement_slug/promote', (req, res, next) ->
    Bluebird.resolve()
      .then load_settlement(req, target: true, leader_only: true, provisional_targets_only: true)
      .tap ([settlement, you, target]) ->
        promote target
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next

  app.post '/settlements/:settlement_slug/leave', (req, res, next) ->
    Bluebird.resolve()
      .then load_settlement(req, allow_provisional: true)
      .tap ([settlement, you]) ->
        leave you, settlement
      .then ([settlement]) ->
        res.redirect "/settlements/#{settlement.slug}"
      .catch next
