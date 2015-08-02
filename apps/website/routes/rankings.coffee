_ = require 'underscore'
Bluebird = require 'bluebird'
moment = require 'moment'
data = require '../../../data'
queries = require '../../../queries'
count_active_characters = Bluebird.promisify(queries.count_active_characters)
count_active_unincorporated_characters = Bluebird.promisify(queries.count_active_unincorporated_characters)
count_total_characters = Bluebird.promisify(queries.count_total_characters)
all_active_members = Bluebird.promisify(queries.all_active_members)

filter_town_pop = (results) ->
  Bluebird.resolve(results)
    .map (settlement) ->
      all_active_members(settlement)
        .then (active_members) ->
          settlement.members = settlement.members.filter (m) ->
            return true if settlement.leader? and settlement.leader._id.toString() is m._id.toString()
            _.some active_members, (am) ->
              am._id.toString() is m._id.toString()
          settlement

rankings =
  active:
    developer_only: true
    type: 'player'
    title: 'Active Players'
    columns: ['Last Active', 'Played For']
    map: (c) ->
      [
        moment(c.last_action).fromNow()
        moment.duration(moment(c.last_action).diff(c.created)).humanize()
      ]
    fn: queries.rankings.active
  inactive:
    developer_only: true
    type: 'player'
    title: 'Inactive Players'
    columns: ['Last Active', 'Played For']
    map: (c) ->
      [
        moment(c.last_action).fromNow()
        moment.duration(moment(c.last_action).diff(c.created)).humanize()
      ]
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
      return s.mapped unless s._id?
      [
        if s.region then data.regions[s.region].name else ''
        s.count ? s.members.length
      ]
    post_process: ({results, active_unincorporated_players}) ->
      Bluebird.resolve()
        .then ->
          filter_town_pop(results)
        .then (results2) ->
          results.push
            name: 'Unincorporated'
            mapped: [
              ''
              active_unincorporated_players
            ]
    fn: queries.rankings.bigtowns

module.exports = (router) ->
  router.get '/rankings/:metric?', (req, res, next) ->
    return res.redirect('/rankings/frags') unless req.params.metric?.length
    config = rankings[req.params.metric]

    Bluebird.resolve()
      .then ->
        throw 'Invalid Metric' unless config?
        throw 'Developers Only' if config.developer_only and not req.session?.developer
      .then ->
        Bluebird.props
          results: Bluebird.promisify(config.fn)()
          active_players: count_active_characters()
          active_unincorporated_players: count_active_unincorporated_characters()
          total_players: count_total_characters()
      .tap (value) ->
        if config.post_process
          config.post_process value
      .then ({results, active_players, total_players}) ->
        res.render 'rankings',
          _: _
          active_count: active_players
          total_count: total_players
          rankings: rankings
          config: config
          data: data
          results: (results ? []).map (r) ->
            object: r
            mapped: config.map r
      .catch next
