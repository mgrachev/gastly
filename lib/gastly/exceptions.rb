module Gastly
  class FetchError < StandardError
    def initialize(url)
      super("Unable to load #{url}")
    end
  end

  PhantomJSError = Class.new(RuntimeError)
  UnknownError   = Class.new(RuntimeError)
end
