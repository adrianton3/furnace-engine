define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  ValueExtractor = {}

  extract = (tree) ->
    if tree instanceof Token
      tree.value
    else if Array.isArray tree
      tree.map extract
    else if typeof tree == 'object'
      ret = {}
      Object.keys(tree).forEach (key) -> ret[key] = extract tree[key]
      ret
    else
      tree

  ValueExtractor.extract = extract

  ValueExtractor