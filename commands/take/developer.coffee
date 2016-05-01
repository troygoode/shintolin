module.exports.can = (character, tile, msg) ->
  throw {
    message: 'Developers Only'
    hard: true
  } unless character.developer
