define [], ->
  AjaxUtil = {}

  AjaxUtil.load = (url, callback) ->
    httpRequest = new XMLHttpRequest()

    httpRequest.onreadystatechange = ->
      if httpRequest.readyState == 4
        if httpRequest.status == 200
          callback httpRequest.responseText
        else
          throw new Error 'Could not retrieve ' + url

    httpRequest.open 'GET', url
    httpRequest.send()

  AjaxUtil