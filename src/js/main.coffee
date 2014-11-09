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
  tree = null
  game = null
  editorWindow = null


  parse = (inText) ->
    try
      tokens = Tokenizer.chop inText
      tree = Parser.parse tokens
      Validator.validate tree

      return ValueExtractor.extract(tree)
    catch ex
      return null


  compile = (tree) ->
    if game
      game.cleanup()

    game = new Game()
    game.init tree
    game.start()
    return


  originUrl = '*'

  editorListener = (e) ->
    e.preventDefault()

    data = e.data
    if data.type == 'compile'
      compile data.tree
    else if data.type == 'request-source'
      emit { type: 'source', source }

    return


  edit = ->
    window.addEventListener 'message', editorListener, false

    editorWindow = window.open(
      'editor.html'
      '_blank'
      'menubar=no, location=no, width=656, height=640'
    )
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

      if editorWindow
        emit { type: 'source', _source }

      tree = parse _source
      compile tree
      document.getElementById('can').focus()
      return

    return


  run: run
