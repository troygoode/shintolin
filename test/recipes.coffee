_ = require 'underscore'
should = require 'should'
data = require '../data'

dummy_character = {}
dummy_tile = {}

describe 'item recipes', ->
  it 'have valid ingredients', ->
    recipes = _.filter data.items, (i) ->
      i.craft?
    _.each recipes, (recipe) ->
      io = recipe.craft dummy_character, dummy_tile
      return unless io?.takes?.items?
      for type of io.takes.items
        console.log "WARNING: Ingredient '#{type}' could not be found for recipe '#{recipe.id}'." unless data.items[type]?
        should.exist(data.items[type])

  it 'have valid tools', ->
    recipes = _.filter data.items, (i) ->
      i.craft?
    _.each recipes, (recipe) ->
      io = recipe.craft dummy_character, dummy_tile
      return unless io?.takes?.tools?
      for type in io.takes.tools
        console.log "WARNING: Tool '#{type}' could not be found for recipe '#{recipe.id}'." unless data.items[type]?
        should.exist(data.items[type])

describe 'building recipes', ->
  it 'have valid ingredients', ->
    recipes = _.filter data.buildings, (i) ->
      i.build?
    _.each recipes, (recipe) ->
      io = recipe.build dummy_character, dummy_tile
      return unless io?.takes?.items?
      for type of io.takes.items
        console.log "WARNING: Ingredient '#{type}' could not be found for building '#{recipe.id}'." unless data.items[type]?
        should.exist(data.items[type])

  it 'have valid tools', ->
    recipes = _.filter data.buildings, (i) ->
      i.build?
    _.each recipes, (recipe) ->
      io = recipe.build dummy_character, dummy_tile
      return unless io?.takes?.tools?
      for type in io.takes.tools
        console.log "WARNING: Tool '#{type}' could not be found for building '#{recipe.id}'." unless data.items[type]?
        should.exist(data.items[type])

describe 'building recipes (repair)', ->
  it 'have valid ingredients', ->
    recipes = _.filter data.buildings, (i) ->
      i.repair?
    _.each recipes, (recipe) ->
      io = recipe.repair dummy_character, dummy_tile
      return unless io?.takes?.items?
      for type of io.takes.items
        console.log "WARNING: Ingredient '#{type}' could not be found for building '#{recipe.id}'." unless data.items[type]?
        should.exist(data.items[type])

  it 'have valid tools', ->
    recipes = _.filter data.buildings, (i) ->
      i.repair?
    _.each recipes, (recipe) ->
      io = recipe.repair dummy_character, dummy_tile
      return unless io?.takes?.tools?
      for type in io.takes.tools
        console.log "WARNING: Tool '#{type}' could not be found for building '#{recipe.id}'." unless data.items[type]?
        should.exist(data.items[type])
