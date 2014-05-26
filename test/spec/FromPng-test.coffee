define ['import-export/FromPng'], (FromPng) ->
  'use strict'

  getImage = (width, height, data) ->
    canvas = document.createElement 'canvas'
    canvas.width = width
    canvas.height = height
    context = canvas.getContext '2d'

    imageData = context.createImageData width, height

    i = 0
    p = 0
    while i < data.length
      imageData.data[p] = data[i]
      i++
      p++

    context.putImageData imageData, 0, 0

    canvas.toDataURL()

  extractData = (fullData) ->
    data = []

    i = 4
    while i < fullData.length
      data.push fullData[i + 0]
      data.push fullData[i + 1]
      data.push fullData[i + 2]
      i += 4

    data


  describe 'FromPng', ->
    describe 'decode', ->
      it 'decodes an image', (done) ->
        data = [0, 9, 0, 255,  110, 220, 190, 255,  120, 120, 120, 255,  250, 251, 252, 255]
        imageUrl = getImage 2, 2, data
        text = FromPng.decode imageUrl, (text) ->
          textData = text.split('').map (char) -> char.charCodeAt 0
          extractedData = extractData data
          expect(textData).toEqual extractedData
          done()