_ = require 'underscore'
fs = require 'fs'
data = require './data'
line_format = /(\s*)(.*)/
tree_txt = fs.readFileSync "#{__dirname}/data/skills/_tree.txt", 'utf-8'

find_all = (nodes) ->
  retval = []
  for node in nodes
    retval.push node
    retval.push child for child in find_all(node.children) if node.children?
  retval

find_ancestors = (node) ->
  ancestors = []
  pointer = node
  while pointer.parent?
    ancestors.push pointer.parent
    pointer = pointer.parent
  ancestors

build_tree = ->

  lines = tree_txt.split '\n'

  # format text into a structured array
  lines = lines.filter (line) ->
    line.length > 0
  indent = lines[1].match(line_format)[1].length
  lines = lines.map (line) ->
    formatted = line.match line_format
    indent: formatted[1].length / indent
    text: formatted[2]

  # assign parents
  lines = lines.reverse()
  just_indents = _.pluck lines, 'indent'
  for l, i in lines
    parent_index = just_indents.indexOf l.indent - 1, i
    if parent_index >= 0
      l.parent = lines[parent_index]
  lines = lines.reverse()

  # assign children and map actually skill objects in
  for l in lines
    l.skill = data.skills[l.text]
    l.children = lines.filter (l2) ->
      l2.parent is l
    delete l.indent

  # return only root nodes
  root = lines.filter (l) ->
    l.parent is undefined

  retval = {}
  for node in root
    node.children.forEach (s) ->
      delete s.parent
    json = JSON.parse node.text
    retval[json.id] =
      id: json.id
      name: json.name
      skills: node.children
      all: find_all node.children

  for l in lines
    delete l.text
    l.ancestors = find_ancestors l
    l.id = l.skill?.id

  retval

module.exports = build_tree()
