module.exports = (app) ->
  app.post '/register', (req, res, next) ->

    #TODO: validate

    now = new Date()
    character =
      name: req.body.username
      x: 0 #TODO: get from settlement
      y: 0 #TODO: get from settlement
      z: 0
      hp: 50
      hp_max: 50
      ap: 100.0
      hunger: 9
      last_action: now

      craft_xp: 0
      warrior_xp: 0
      herbal_xp: 0
      wanderer_xp: 0

      email: req.body.email
      password: req.body.password #TODO: hash
      #donated: false #don't need to store
      #banned: false #don't need to store

      settlement: req.body.settlement
      settlement_joined: now

      kills: 0
      frags: 1
      deaths: 0
      revives: 0
      created: now
      last_revived: now

      bio: ''
      image_url: ''

    #TODO: save

    res.redirect '/game'
