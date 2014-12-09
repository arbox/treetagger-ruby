module TreeTagger
  # A simple error wrapper,
  # you can intercept all error from the library.
  class Error < StandardError; end

  # Somethig went wrong: no env variable, data not coded prperly etc.
  ExternalError = Class.new(Error)

  # Exectution error, an assert like exception.
  RuntimeError = Class.new(Error)

  # User tries to use the lib in a wrong manner, e.g. provides
  # wrong parameters.
  UserError = Class.new(Error)
end
