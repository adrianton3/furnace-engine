define [], ->
  ToPng = {}

  dataToCanvas = (data) ->
    canvas = document.createElement 'canvas'

    sqrt = Math.ceil Math.sqrt ((data.length + 3) / 3)
    canvas.width = sqrt
    canvas.height = sqrt
    context = canvas.getContext '2d'

    imageData = context.createImageData sqrt, sqrt

    imageData.data[0] = data.length // 256
    imageData.data[1] = data.length % 256
    imageData.data[3] = 255

    i = 0
    p = 4
    while i < data.length
      imageData.data[p + 0] = data[i + 0]
      imageData.data[p + 1] = data[i + 1]
      imageData.data[p + 2] = data[i + 2]
      imageData.data[p + 3] = 255
      i += 3
      p += 4

    context.putImageData imageData, 0, 0
    canvas

  maxAlpha = (rawData) ->
    data = []
    i = 0
    while i < rawData.length
      data.push rawData[i + 0]
      data.push rawData[i + 1]
      data.push rawData[i + 2]
      data.push 255
      i += 3

    data

  ToPng.encode = (text) ->
    data = [];
#    data.push Math.floor(text.length / 256)
#    data.push text.length % 256
#    data.push 0

    i = 0
    while i < text.length
      data.push text.charCodeAt i
      i++

    # maxAlpha
    dataToCanvas data

  ToPng