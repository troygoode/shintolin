_ = require 'underscore'
BPromise = require 'bluebird'
moment = require 'moment'
data = require '../../../data'
queries = require '../../../queries'
count_active_characters = BPromise.promisify(queries.count_active_characters)
count_total_characters = BPromise.promisify(queries.count_total_characters)

rankings =
  active:
    developer_only: true
    type: 'player'
    title: 'Active Players'
    columns: 'Last Active'
    map: (c) ->
      moment(c.last_action).fromNow()
    fn: queries.rankings.active
  inactive:
    developer_only: true
    type: 'player'
    title: 'Inactive Players'
    columns: 'Last Active'
    map: (c) ->
      moment(c.last_action).fromNow()
    fn: queries.rankings.inactive
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
        if s.region then data.regions[s.region].name else ''
        s.count ? s.members.length
      ]
    post_process: ({results, total_players}) ->
      incorporated = 0
      for s in results
        incorporated += s.members.length
      results.push
        name: 'Unincorporated'
        count: total_players - incorporated
    fn: queries.rankings.bigtowns

module.exports = (router) ->
  router.get '/rankings/:metric?', (req, res, next) ->
    return res.redirect('/rankings/frags') unless req.params.metric?.length
    config = rankings[req.params.metric]

    BPromise.resolve()
      .then ->
        throw 'Invalid Metric' unless config?
        throw 'Developers Only' if config.developer_only and not req.session?.developer
      .then ->
        BPromise.props
          results: BPromise.promisify(config.fn)()
          active_players: count_active_characters()
          total_players: count_total_characters()
      .tap (value) ->
        if config.post_process
          config.post_process value
      .then ({results, active_players}) ->
        res.render 'rankings',
          _: _
          active_count: active_players
          rankings: rankings
          config: config
          data: data
          results: (results ? []).map (r) ->
            object: r
            mapped: config.map r
      .catch next
