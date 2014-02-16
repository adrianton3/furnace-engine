define [], ->
  colorBindings =
    'w': 'rgb(255, 255, 255)'
    'b': 'rgb(0, 0, 0)'
    '.': 'rgba(0, 0, 0, 0)'

  spritesByName =
    '0': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
  '''
    '1': '''
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
.......wwb......
  '''
    '2': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
..wwwwwwwwwwwb..
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwwwwwwwwwwb..
  '''
    '3': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
.......wwwwwwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
  '''
    '4': '''
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
  '''
    '5': '''
..wwwwwwwwwwwb..
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwwwwwwwwwwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
  '''
    '6': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
..wwb...........
..wwb...........
..wwb...........
..wwb...........
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
  '''
    '7': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
  '''
    '8': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
  '''
    '9': '''
..wwwwwwwwwwwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
...........wwb..
..wwb......wwb..
..wwb......wwb..
..wwwwwwwwwwwb..
  '''

  convert = (stringedSprites) ->
    ret = {}
    for key, sprite of stringedSprites
      ret[key] = sprite.split('\n').map (line) -> { s: line }

    ret

  {
    colorBindings: colorBindings
    spritesByName: convert spritesByName
  }