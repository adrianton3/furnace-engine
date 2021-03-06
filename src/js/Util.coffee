define [], ->
  'use strict'

  Util = {}


  Util.maptree = (tree, fun, predicate) ->
    return fun(tree)  if predicate(tree)
    if tree instanceof Array
      tree.map (elem) ->
        Util.maptree elem, fun, predicate

    else if typeof tree is 'object'
      newObj = {}
      for key of tree
        newObj[key] = Util.maptree(tree[key], fun, predicate)
      newObj


  Util.findFirst = (array, predicate) ->
    i = 0

    while i < array.length
      if predicate(array[i], i)
        return (
          element: array[i]
          index: i
        )
      i++
    return


  Util.removeFirst = (array, predicate) ->
    firstMatch = Util.findFirst(array, predicate)
    array.splice firstMatch.index, 1  if firstMatch
    return


  Util.remove = (array, element) ->
    Util.removeFirst array, (entry) ->
      entry is element
    return


  Util.objectToArray = (object, nameProperty, dataProperty) ->
    array = []
    for key of object
      entry = {}
      entry[nameProperty] = key
      entry[dataProperty] = object[key]
      array.push entry
    array


  Util.arrayToObject = (array, nameProperty, dataProperty) ->
    object = {}
    array.forEach (element) ->
      object[element[nameProperty]] = element[dataProperty]
      return
    object


  Util.indexBy = (array, nameProperty) ->
    map = {}
    if typeof nameProperty == 'string'
      array.forEach (element) ->
        map[element[nameProperty]] = element
        return
    else
      array.forEach (element) ->
        map[nameProperty(element)] = element
        return
    map


  Util.pluck = (array, propertyName) ->
    array.map (element) -> element[propertyName]


  Util.getSet = (array, nameProperty) ->
    set = {}

    if nameProperty?
      array.forEach (element) ->
        set[element[nameProperty]] = true
        return
    else
      array.forEach (element) ->
        set[element] = true
        return
    set


  Util.mapOnKeys = (object, fun) ->
    ret = {}
    for key of object
      ret[key] = fun(object[key])
    ret


  Util.groupBy = (array, fun) ->
    groups = {}
    array.forEach (element) ->
      ret = fun(element)
      groups[ret] = [] unless groups[ret]
      groups[ret].push element
      return
    groups


  Util.getDuplicate = (array) ->
    elementsByName = {}
    duplicate = null
    index = -1

    array.every (element, i) ->
      if elementsByName[element]?
        duplicate = element
        index = i
        false
      else
        elementsByName[element] = true
        true

    value: duplicate
    index: index


  Util.capitalize = (string) ->
    string.substring(0, 1).toUpperCase() + string.substring(1)


  Util.isCapitalized = (string) ->
    'A' <= string[0] <= 'Z'
#    string.substring(0, 1).toUpperCase() == string.substring(0, 1)

  Util
