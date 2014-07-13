define [], ->
  CustomMatchers = {}

  CustomMatchers.toThrowWithMessage = (util, customEqualityTesters) ->
    compare: (actual, expected) ->
      result = {}

      try
        actual()
        result.pass = false
        result.message = 'Expected function to throw an exception'
      catch ex
        if ex.message != expected
          result.pass = false
          result.message =
              'Expected function to throw an exception with the message ' + expected +
              ' but instead received ' + (if ex.message? then ex.message else 'no message')
        else
          result.pass = true

      result


  CustomMatchers