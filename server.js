/* global require, __dirname */

require("babel/register");
require("coffee-script/register");

var path = require("path"),
  recluster = require("recluster"),
  config = require("./config"),
  cluster = recluster(path.join(__dirname, "./apps/website/app.coffee"), {workers: config.web_concurrency || 1});

cluster.run();
