require 'phantomjs'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'

module Gastly
  class Screenshot

    SCRIPT_PATH = File.expand_path('../script.js', __FILE__)
    DEFAULT_TIMEOUT = 0
    DEFAULT_BROWSER_WIDTH = 1440
    DEFAULT_BROWSER_HEIGHT = 900
    DEFAULT_FILE_NAME = 'output'.freeze
    DEFAULT_FILE_FORMAT = '.png'.freeze

    attr_writer :timeout, :browser_width, :browser_height
    attr_accessor :url, :selector, :cookies

    def initialize(url, **kwargs)
      kwargs.assert_valid_keys(:timeout, :browser_width, :browser_height, :selector, :cookies)

      @url = url
      self.cookies = kwargs.delete(:cookies)

      kwargs.each { |key, value| instance_variable_set(:"@#{key}", value) }
    end

  end
end