define [
  'Util'
  'SpriteSheet'
], (
  Util
  SpriteSheet
) ->

  SpriteSheetGenerator = {}

  SpriteSheetGenerator.generate = (stringedSprites, colorBindings, scale) ->
    pixel = (x, y, color) ->
      con2d.fillStyle = color
      con2d.fillRect x * scale, y * scale, scale, scale
      return

    paint = (x, y, data) ->
      baseOffsetX = x * data.length
      baseOffsetY = y * data.length
      data.forEach (line, i) ->
        line.split('').forEach (char, j) ->
          color = colorsByBinding[char]
          pixel baseOffsetX + j, baseOffsetY + i, color
          return
        return
      return

    colorsByBinding = Util.arrayToObject(colorBindings.map((binding) ->
      stringedColor = if binding.alpha?
          "rgba(#{binding.red},#{binding.green},#{binding.blue},#{binding.alpha})"
        else
          "rgb(#{binding.red},#{binding.green},#{binding.blue})"

      name: binding.name
      stringedColor: stringedColor
    ), 'name', 'stringedColor')

    width = Math.ceil(Math.sqrt(stringedSprites.length))
    canvas = document.createElement('canvas')
    canvas.width = stringedSprites[0].data.length * width * scale
    canvas.height = stringedSprites[0].data.length * width * scale
    con2d = canvas.getContext('2d')

    stringedSprites.forEach (stringedSprite, index) ->
      x = index % width
      y = index // width
      paint x, y, stringedSprite.data
      return

    dataURL = canvas.toDataURL('image/png')
    image = new Image()
    image.src = dataURL
    spriteSheet = new SpriteSheet(image, width, width)

    namedSprites = stringedSprites.map (stringedSprite, index) ->
      x = index % width
      y = index // width
      name: stringedSprite.name
      sprite: spriteSheet.getSprite(x, y)

    namedSprites

  SpriteSheetGenerator