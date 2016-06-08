db = require '../db'

module.exports = (ip) ->
  QUERY =
    ip: ip

  db.hits().find(QUERY).sort(last_access: -1).limit(30).toArray()
