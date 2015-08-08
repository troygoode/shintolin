module.exports =
  name: 'Carpentry'
  description: 'Craft timber, sickles, and carpentry tools; crafting costs less AP when in a workshop.'

  actions:
    craft: (character, tile, gives, takes) ->
      return unless tile?.z isnt 0 and tile?.building is 'workshop'
      return unless takes?.ap? and takes.ap >= 2
      takes.ap = Math.ceil(takes.ap / 2)
