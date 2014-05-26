define ['import-export/ToPng'], (ToPng) ->
  'use strict'

  getImageData = (image) ->
    canvas = document.createElement 'canvas'
    canvas.width = image.width
    canvas.height = image.height
    context = canvas.getContext '2d'
    context.drawImage image, 0, 0
    context.getImageData(0, 0, image.width, image.height).data

  extractData = (fullData) ->
    data = []

    i = 4
    while i < fullData.length
      data.push fullData[i + 0]
      data.push fullData[i + 1]
      data.push fullData[i + 2]
      i += 4

    data


  describe 'ToPng', ->
    describe 'encode', ->
      it 'encodes text as an image', () ->
        text = 'a"z 12\n\t{!'
        image = ToPng.encode text
        imageData = getImageData image

        textData = text.split('').map (char) -> char.charCodeAt 0
        extractedData = extractData imageData
        extractedData = extractedData.slice 0, text.length
        expect(extractedData).toEqual textData