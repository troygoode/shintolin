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

  leader = settlement.leader._id.toString() is member._id.toString()

  _id: member._id
  name: member.name
  slug: member.slug
  joined: member.joined
  voting_for: member.voting_for
  leader: leader
  provisional: member.joined > yesterday and not leader
  votes: count_votes settlement, member

module.exports = (app) ->
  app.get '/settlements/:settlement_slug', (req, res, next) ->
    queries.get_settlement_by_slug req.param('settlement_slug'), (err, settlement) ->
      return next(err) if err?
      return next() unless settlement?
      res.render 'settlement',
        settlement: settlement
        members: settlement.members.map (m) -> visit_member settlement, m
