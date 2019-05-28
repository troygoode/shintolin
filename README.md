# Shintolin

A node.js port of [Isaac Lewis' Ruby version of Shintolin](https://github.com/IsaacLewis/Shintolin) - a persistent multiplayer browser game, set in the stone age.

## Local Development / Testing (DOCKER)

* Download the code via [git](http://git-scm.com/): `$ git clone https://github.com/troygoode/shintolin`
* Install [docker](https://www.docker.com/)

```bash
# on host
docker-compose up shintolin3-mongo # start mongo in background
docker-compose run shintolin3-mongo bash # bash into mongo server

# within mongo container
DIR=/host/... # tab complete the path to the Heroku mongo backup
mongorestore --db heroku_8xb5fctf $DIR
exit

# back on host
npm install
npm start
```

## Local Development / Testing (Old)

### Running the Game

* Go into the Shintolin directory: `$ cd shintolin`
* Get latest code from [git](http://git-scm.com/): `$ git pull`
* Install dependencies via [npm](http://npmjs.org/): `$ npm install`
* Create a separate Terminal tab (CMD+T) and run [mongodb](http://www.mongodb.org/): `$ mongod`
* In the original tab, run some bootstrap scripts: `$ bin/dev/bootstrap`
* Finally, run Shintolin: `$ npm start`
* Browse to [http://localhost:3000](http://localhost) in your web browser to play. You can log in as "ecce@example.com" using the password "password".

## Deploying to Heroku

* Create an account on [Heroku.com](http://heroku.com/)
* Install the [Heroku Toolbelt](https://toolbelt.heroku.com/)
* From the Shintolin directory, create a new Heroku app: `$ heroku create`
* Add the [MongoLab add-on](https://addons.heroku.com/mongolab): `$ heroku addons:add mongolab`
* Add the [Heroku Scheduler add-on](https://addons.heroku.com/scheduler): `$ heroku addons:add scheduler:standard`
* Open the Heroku Scheduler configuration screen: `$ heroku addons:open scheduler`
  * Add an hourly task that runs at `:00`, pointing to: `$ ./bin/tick_ap/_tick`
  * Add a daily task that runs at `00:00`, pointing to: `$ ./bin/tick_day/_tick`
  * Add three more daily tasks that run at `00:00`, `08:00`, and `16:00` - each pointing to: `$ ./bin/tick_hunger/_tick`
* Turn on production mode: `heroku config:add NODE_ENV=production`
* Use a safe session secret: `heroku config:add SESSION_SECRET=<YOUR_SECRET_HERE>`
* Push your code to Heroku: `git push heroku master`
* Start your free instance: `heroku ps:scale web=1`
* Log in to your game: `heroku open`

## License

Shintolin: a persistent multiplayer browser game, set in the stone age.
Copyright (C) 2013 Troy Goode

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program.  If not, see [<http://www.gnu.org/licenses/>](http://www.gnu.org/licenses/).
