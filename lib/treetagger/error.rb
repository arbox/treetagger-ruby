module TreeTagger
  # A simple error wrapper,
  # you can intercept all error from the library.
  class Error < StandardError; end

  # Somethig went wrong: no env variable, data not coded prperly etc.
  class ExternalError < Error
  end

  # Exectution error, an assert like exception.
  class RuntimeError < Error
    
  end

  # User tries to use the lib in a wrong manner, e.g. provides
  # wrong parameters.
  class UserError < Error
  end
end
