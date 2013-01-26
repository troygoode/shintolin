commands = require '../../commands'
queries = require '../../queries'
days_until_full_status = 1

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

module.exports = (app) ->

  app.get '/settlements/:settlement_slug', (req, res, next) ->
    queries.get_settlement_by_slug req.param('settlement_slug'), (err, settlement) ->
      return next(err) if err?
      return next() unless settlement?
      res.render 'settlement',
        settlement: settlement
        members: settlement.members.map (m) -> visit_member settlement, m
        editable: req.session.character? and settlement.leader? and req.session.character is settlement.leader._id.toString()

  app.post '/settlements/:settlement_slug', (req, res, next) ->
    queries.get_settlement_by_slug req.param('settlement_slug'), (err, settlement) ->
      return next(err) if err?
      return next() unless settlement?
      leader = req.session.character? and settlement.leader? and req.session.character is settlement.leader._id.toString()
      return next('Unauthorized') unless leader
      update =
        description: req.body.description
        name: req.body.name
        image_url: req.body.image_url
        motto: req.body.motto
        leader_title: req.body.leader_title
        website_url: req.body.website_url
        open: Boolean(req.body.open)
      commands.update_settlement_profile settlement, update, (err) ->
        return next(err) if err?
        res.redirect "/settlements/#{settlement.slug}"
