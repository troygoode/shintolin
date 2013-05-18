_ = require 'underscore'
coords_in_circle_around = require '../queries/coords_in_circle_around'

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
  it 'works with a radius of 1', (done) ->
    #arrange/act
    viz = visualize x:0, y:0, 1

    #assert
    expected = """
               _X_
               XXX
               _X_
               """
    viz.should.eql expected
    done()

  it 'works with a radius of 2', (done) ->
    #arrange/act
    viz = visualize x:0, y:0, 2

    #assert
    expected = """
               __X__
               _XXX_
               XXXXX
               _XXX_
               __X__
               """
    viz.should.eql expected
    done()

  it 'works with a radius of 3', (done) ->
    #arrange/act
    viz = visualize x:0, y:0, 3
    console.log viz

    #assert
    expected = """
               ___X___
               __XXX__
               _XXXXX_
               XXXXXXX
               _XXXXX_
               __XXX__
               ___X___
               """
    console.log "\n#{viz}\n"
    console.log "\n#{expected}\n"
    viz.should.eql expected
    done()
