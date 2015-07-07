data = require('require-directory')(module, null, exclude: /\.txt$|\/actions\//)

for key, obj of data.buildings
  obj.id ?= key

for key, obj of data.creatures
  obj.id ?= key
  obj.name ?= key
  obj.plural ?= obj.name + 's'

for key, obj of data.items
  obj.id ?= key

for key, obj of data.regions
  obj.id ?= key

for key, obj of data.skills
  obj.id ?= key

for key, obj of data.terrains
  obj.id ?= key

module.exports = data
