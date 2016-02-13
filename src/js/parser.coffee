define [
  'tokenizer/Tokenizer'
  'parser/Parser'
  'extractor/ValueExtractor'
  'prettyprinter/PrettyPrinter'

  'editor/furnace-mode'
], (
  Tokenizer
  Parser
  ValueExtractor
  PrettyPrinter
) ->
  'use strict'

  inWorldEditor = null
  outTokensEditor = null
  outInterpretedEditor = null
  errorLine = null


  getEditor = (elementId) ->
    editor = ace.edit elementId
    editor.setTheme 'ace/theme/monokai'
    editor


  setupEditors = ->
    inWorldEditor = getEditor 'in-world'
    inWorldEditor.getSession().setMode 'ace/mode/furnace'
    inWorldEditor.on 'input', parse
    inWorldEditor.$blockScrolling = Infinity

    outTokensEditor = getEditor 'out-tokens'
    outTokensEditor.setReadOnly true
    outTokensEditor.$blockScrolling = Infinity

    outInterpretedEditor = getEditor 'out-world'
    outInterpretedEditor.setReadOnly true
    outInterpretedEditor.$blockScrolling = Infinity
    return


  parse = ->
    inText = inWorldEditor.getValue()
    try
      tokens = Tokenizer.chop inText
      outTokensText = tokens.join '\n'
      outTokensEditor.setValue outTokensText, -1

      tree = Parser.parse tokens
      valueTree = ValueExtractor.extract tree
      outTreeText = PrettyPrinter.print valueTree
      outInterpretedEditor.setValue outTreeText, -1

      if errorLine != null
        inWorldEditor.getSession().setAnnotations []
        errorLine = null

      document.getElementById('status').classList.add 'ok'
      document.getElementById('status').classList.remove 'err'
      document.getElementById('status').innerHTML = 'OK'
    catch ex
      if ex.line or ex.token
        line = ex.line or ex.token.coords.line
        if line != errorLine && errorLine != null
          inWorldEditor.getSession().setAnnotations []

        errorLine = line
        inWorldEditor.getSession().setAnnotations([
          row: errorLine - 1
          text: ex.message || ex
          type: 'error'
        ])

      document.getElementById('status').classList.add 'err'
      document.getElementById('status').classList.remove 'ok'
      document.getElementById('status').innerHTML = ex.message or ex
    return


  run = ->
    setupEditors()
    inWorldEditor.setValue window.sampleSpecs['little-furnace'], -1
    parse()
    return


  { run }