/* global require */

require("coffee-script/register");

var config = require("./config"),
  cluster = require("./apps/cluster"),
  app = require("./apps/website/app");

cluster(app, config.maximum_cpus);
