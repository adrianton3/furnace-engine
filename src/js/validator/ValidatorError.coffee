define [], ->

  ValidatorError = (token, message) ->
    @token = token
    @message = message
    return

  ValidatorError:: = Object.create Error::
  ValidatorError::constructor = ValidatorError

  ValidatorError