require('coffee-script/register');

var config = require('./config');

if(config.nodetime_api_key && config.nodetime_api_key.length){
  require('nodetime').profile({
    accountKey: config.nodetime_api_key,
    appName: 'Shintolin',
    debug: true
  });
}

var cluster = require('./apps/cluster'),
    app = require('./apps/website/app');

cluster(app, config.maximum_cpus);
