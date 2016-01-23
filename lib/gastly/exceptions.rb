module Gastly
  class FetchError < StandardError
    attr_reader :url

    def initialize(url)
      super("Unable to load #{url}")
    end
  end

  PhantomJSError = Class.new(RuntimeError)
  UnknownError   = Class.new(RuntimeError)
end
