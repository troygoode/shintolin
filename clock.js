/* global require, __dirname */

require('babel/register')
require('coffee-script/register')

var clock = require('node-schedule')
var spawn = require('child_process').spawnSync

// every 10 minutes

clock.scheduleJob('0 * * * *', function () {
  console.log(spawn('bin/tick_ap/_tick').stdout.toString())
})

// thrice-daily

clock.scheduleJob('0 0,8,16 * * *', function () {
  console.log(spawn('bin/tick_hunger/_tick').stdout.toString())
})

// daily

clock.scheduleJob('0 0 * * *', function () {
  console.log(spawn('bin/tick_day/_tick').stdout.toString())
})

console.log('The clock is ticking.')
