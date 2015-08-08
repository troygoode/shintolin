module.exports =
  name: 'Carpentry'
  description: 'Craft timber, sickles, and stone carpentry tools; crafting those items costs less AP when in a workshop.'

  actions:
    craft: (character, tile, gives, takes) ->
      return unless tile?.z isnt 0 and tile?.building is 'workshop'
      return unless takes?.ap? and takes.ap >= 2
      return unless takes?.tags?.length and takes.tags.indexOf('carpentry:ap-reduction') isnt -1
      takes.ap = Math.ceil(takes.ap / 2)
