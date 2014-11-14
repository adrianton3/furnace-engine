define [
  'SystemBus'
  'World'
  'generator/Generator'
], (
  SystemBus
  World
  Generator
) ->
  'use strict'


  Game = ->
    @world = null
    @requestId = null


  Game::init = (tree) ->
    Generator.generate(tree)
    .then (world) =>
      @world = world
      @world.init()


  Game::start = ->
    frame = =>
      @world.update()
      if Math.random() < 0.1 then @world.draw()
      @requestId = window.requestAnimationFrame frame

    frame()


  Game::cleanup = ->
    window.cancelAnimationFrame @requestId
    SystemBus.reset()


  Game
