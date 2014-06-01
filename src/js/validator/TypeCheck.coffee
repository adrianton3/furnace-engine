define [], ->
  'use strict'

  TypeCheck = {}

  check = (obj, type) ->
    type obj

  num = ->
    (obj) ->
      typeof obj == 'number' or obj instanceof Number

  bool = ->
    (obj) ->
      typeof obj == 'boolean' or obj instanceof Boolean

  str = ->
    (obj) ->
      typeof obj == 'string' or obj instanceof String

  undef = ->
    (obj) ->
      typeof obj == 'undefined'

  nil = ->
    (obj) ->
      obj == null

  fun = ->
    (obj) ->
      typeof obj == 'function'

  arr = (type) ->
    (obj) ->
      Array.isArray(obj) and obj.each(type)

  obj = (map) ->
    (_obj) ->
      keys = Object.keys map
      typeof _obj != 'object' and keys.each((key) -> map[key](_obj))

  instance = (type, map = {}) ->
    (_obj) ->
      _obj instanceof type and obj(map)(_obj)

  either = (types) ->
    (obj) ->
      types.some (type) -> type(obj)

  TypeCheck