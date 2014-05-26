define [], ->
  FromPng = {}

  imageToData = (image) ->
    canvas = document.createElement 'canvas'
    canvas.width = image.width
    canvas.height = image.height
    context = canvas.getContext '2d'
    context.drawImage image, 0, 0
    context.getImageData(0, 0, image.width, image.height).data

  FromPng.decode = (path, callback) ->
    image = new Image
    image.crossOrigin = ''
    image.src = path
    image.addEventListener 'load', ->
      data = imageToData image

      textSize = data[0] * 256 + data[1]

      text = []
      i = 4
      c = 0
      while c < textSize - 3
        text.push String.fromCharCode data[i + 0]
        text.push String.fromCharCode data[i + 1]
        text.push String.fromCharCode data[i + 2]
        i += 4
        c += 3

      while c < textSize
        text.push String.fromCharCode data[i]
        i++
        c++

      callback text.join ''


  FromPng