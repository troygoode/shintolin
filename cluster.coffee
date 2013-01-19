cluster = require 'cluster'
http = require 'http'
os = require 'os'
website = require './website/app'
config = require './config'

if cluster.isMaster
  cpus = os.cpus().length
  console.log "CPU Count: #{cpus}"
  cluster.fork() for i in [1..cpus]
  cluster.on 'exit', (worker, code, signal) ->
    console.log "worker #{worker.process.pid} died"
else
  website.listen config.port, ->
    console.log "Shintolin listening on port #{config.port}."
