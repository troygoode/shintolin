module.exports = require('require-directory')(module)

module.exports.hard =
  developer: require('./developer')
  skill: require('./skill')
