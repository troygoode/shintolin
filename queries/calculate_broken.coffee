data = require '../data'

module.exports = (tools) ->
  broken = []
  for tool in tools
    tool_type = data.items[tool]
    broken.push tool if tool_type.break_odds? and Math.random() <= tool_type.break_odds
  broken
