_ = require 'underscore'
moment = require 'moment'
data = require '../../../data'
queries = require '../../../queries'

rankings =
  active:
    developer_only: true
    type: 'player'
    title: 'Active Players'
    columns: 'Last Active'
    map: (c) ->
      moment(c.last_action).fromNow()
    fn: queries.rankings.active
  frags:
    type: 'player'
    title: 'Frags'
    description: 'Frags measure not just the number of foes killed, but the quality of one\'s opponents. New players begin with one frag, and when a character is knocked out, the attacker takes half their frags (rounded up).'
    map: (c) ->
      c.frags
    fn: queries.rankings.frags
  kills:
    type: 'player'
    title: 'Kills'
    map: (c) ->
      c.kills
    fn: queries.rankings.kills
  deaths:
    type: 'player'
    title: 'Deaths'
    map: (c) ->
      c.deaths
    fn: queries.rankings.deaths
  revives:
    type: 'player'
    title: 'Revives'
    map: (c) ->
      c.revives
    fn: queries.rankings.revives
  younguns:
    type: 'player'
    title: 'Newest Players'
    columns: 'Joined'
    map: (c) ->
      moment(c.created).fromNow()
    fn: queries.rankings.younguns
  oldies:
    type: 'player'
    title: 'Oldest Players'
    columns: 'Played Since'
    map: (c) ->
      moment(c.created).fromNow()
    fn: queries.rankings.oldies
  survival:
    type: 'player'
    title: 'Longest Surviving Players'
    columns: 'Alive Since'
    map: (c) ->
      moment(c.last_revived).fromNow()
    fn: queries.rankings.survival
  oldtowns:
    type: 'settlement'
    title: 'Oldest Settlements'
    columns: ['Region', 'Founded']
    map: (s) ->
      [
        data.regions[s.region].name
        moment(s.founded).fromNow()
      ]
    fn: queries.rankings.oldtowns
  newtowns:
    type: 'settlement'
    title: 'Newest Settlements'
    columns: ['Region', 'Founded']
    map: (s) ->
      [
        data.regions[s.region].name
        moment(s.founded).fromNow()
      ]
    fn: queries.rankings.newtowns
  bigtowns:
    type: 'settlement'
    title: 'Most Populated Settlements'
    columns: ['Region', 'Population']
    map: (s) ->
      [
        data.regions[s.region].name
        s.members.length
      ]
    fn: queries.rankings.bigtowns

module.exports = (router) ->
  router.get '/rankings', (req, res, next) ->
    queries.active_characters (err, active_count) ->
      return next(err) if err?

      config = rankings[req.query.metric]
      return next('Invalid Metric') unless config?
      return next('Developers Only') if config.developer_only and not req.session?.developer

      config.fn (err, results) ->
        return next(err) if err?
        res.render 'rankings',
          _: _
          active_count: active_count
          rankings: rankings
          config: config
          results: (results ? []).map (r) ->
            object: r
            mapped: config.map r
