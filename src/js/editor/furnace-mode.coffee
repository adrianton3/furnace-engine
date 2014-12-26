define ['editor/furnace-rules'], ->
  'use strict'

  ace.define 'ace/mode/furnace', (require_, exports, module) ->
    require_ 'ace/theme/furnace-monokai'
    oop = require_ 'ace/lib/oop'
    TextMode = require_('./text').Mode
    Tokenizer = require_('ace/tokenizer').Tokenizer
    HighlightRules = require_('ace/mode/furnace-rules').FurnaceHighlightRules

    Mode = ->
      @$tokenizer = new Tokenizer new HighlightRules().getRules()
      return

    oop.inherits Mode, TextMode

    exports.Mode = Mode;
    return