cluster = require 'cluster'
http = require 'http'
os = require 'os'
config = require '../config'

module.exports = (app, max) ->
  if cluster.isMaster and max > 1
    cpus = os.cpus().length
    cpus = max if max < cpus
    console.log "CPU Count: #{cpus}"
    cluster.fork() for i in [1..cpus]
    cluster.on 'exit', (worker, code, signal) ->
      console.log "worker #{worker.process.pid} died"
  else
    app.listen config.port, ->
      console.log "Shintolin listening on port #{config.port}."
