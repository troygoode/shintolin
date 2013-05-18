_ = require 'underscore'
coords_in_circle_around = require '../queries/coords_in_circle_around'
RADIUS_1 = """
           _X_
           XXX
           _X_
           """
RADIUS_2 = """
           __X__
           _XXX_
           XXXXX
           _XXX_
           __X__
           """
RADIUS_3 = """
           ___X___
           _XXXXX_
           _XXXXX_
           XXXXXXX
           _XXXXX_
           _XXXXX_
           ___X___
           """

visualize = (center, radius) ->
  ret = ''
  in_circle = coords_in_circle_around center, radius
  for y in [center.y - radius..center.y + radius]
    line = ''
    for x in [center.x - radius..center.x + radius]
      if _.some(in_circle, (coord) -> coord.x is x and coord.y is y)
        line += 'X'
      else
        line += '_'
    ret += "#{line}\n"
  ret.substring(0, ret.length - 1)

describe 'coords_in_circle_around', ->
  it 'works with a radius of 1', ->
    viz = visualize x:0, y:0, 1
    viz.should.eql RADIUS_1

  it 'works with a radius of 1 (offset)', ->
    viz = visualize x:5000, y:-2000, 1
    viz.should.eql RADIUS_1

  it 'works with a radius of 2', ->
    viz = visualize x:0, y:0, 2
    viz.should.eql RADIUS_2

  it 'works with a radius of 3', ->
    viz = visualize x:0, y:0, 3
    viz.should.eql RADIUS_3
