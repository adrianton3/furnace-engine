define ['editor/furnace-rules'], ->
  'use strict'

  ace.define 'ace/mode/furnace', (require, exports, module) ->
    require 'ace/theme/furnace-monokai'
    oop = require 'ace/lib/oop'
    TextMode = require('./text').Mode
    Tokenizer = require('ace/tokenizer').Tokenizer
    HighlightRules = require('ace/mode/furnace-rules').FurnaceHighlightRules

    Mode = ->
      @$tokenizer = new Tokenizer new HighlightRules().getRules()
      return

    oop.inherits Mode, TextMode

    exports.Mode = Mode;
    return