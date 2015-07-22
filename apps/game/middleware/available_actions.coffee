_ = require 'underscore'
BPromise = require 'bluebird'
data = require '../../../data'
actions = require '../../../data/actions'

module.exports = (check_for_action) ->
  (req, res, next) ->
    BPromise.resolve()
      .then ->
        actions._default req.character, req.tile

      .tap (action_keys) ->
        if check_for_action and not _.contains(action_keys, check_for_action)
          throw "The action #{check_for_action} is not allowed here."

      .then (action_keys) ->
        hash = {}
        for key in action_keys
          hash[key] = if actions[key]? then actions[key](req.character, req.tile) else true
        BPromise.props hash

      .then (available_actions) ->
        req.actions = available_actions
        res.locals.actions = available_actions
        next()

      .catch (err) ->
        next err
