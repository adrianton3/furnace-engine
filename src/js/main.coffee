define [
  'SystemBus'
  'Text'
  'Game'
  'tokenizer/Tokenizer'
  'parser/Parser'
  'validator/Validator'
  'extractor/ValueExtractor'
  'KeyListener'
  'import-export/FromPng'
  'AjaxUtil'
], (
  SystemBus
  Text
  Game
  Tokenizer
  Parser
  Validator
  ValueExtractor
  KeyListener
  FromPng
  AjaxUtil
) ->
  'use strict'


  source = ''
  game = null
  editorWindow = null
  editorListenerInstalled = false


  parse = (inText) ->
    try
      tokens = Tokenizer.chop inText
      tree = Parser.parse tokens
      Validator.validate tree

      return ValueExtractor.extract tree
    catch ex
      console.error ex
      return null


  compile = (tree) ->
    if game
      game.cleanup()

    game = new Game()
    game.init tree
    game.start()
    return


  editorEventHandlers =
    'compile': (data) ->
      tree = parse data.source
      compile tree
    'request-source': (data) ->
      emit { type: 'source', source }


  originUrl = '*'

  editorListener = (e) ->
    e.preventDefault()

    data = e.data
    if data.type?
      editorEventHandlers[data.type](data)

    return


  edit = ->
    if not editorListenerInstalled
      editorListenerInstalled = true
      window.addEventListener 'message', editorListener, false

    if not editorWindow? or editorWindow.closed
      editorWindow = window.open(
        'editor.html'
        '_blank'
        'menubar=no, location=no, width=656, height=640'
      )
    else
      editorWindow.focus()

    return


  emit = (data) ->
    editorWindow.postMessage data, originUrl
    return


  setupGUI = ->
    editButton = document.getElementById('edit')
    editButton.addEventListener 'click', edit
    return


  checkUrl = (callback) ->
    urlParams = purl(true).param()

    if urlParams.spec
      callback urlParams.spec
    else if urlParams.png
      FromPng.decode urlParams.png, (text) ->
        callback text
    else if urlParams.text
      AjaxUtil.load urlParams.text, (text) ->
        callback text
    else if urlParams.sample
      sample = window.sampleSpecs[urlParams.sample]
      callback sample or window.sampleSpecs['little-furnace']
    else
      callback window.sampleSpecs['little-furnace']
    return


  run = ->
    setupGUI()
    checkUrl (_source) ->
      source = _source
      Text.init()
      document.getElementById('can').tabIndex = 0
      KeyListener.init document.getElementById 'can'

      tree = parse _source
      compile tree

      document.getElementById('can').focus()
      return

    return


  run: run
