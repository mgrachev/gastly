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
    attr_accessor :url, :selector, :cookies, :proxy_host, :proxy_port
    attr_reader :tempfile

    def initialize(url, **kwargs)
      kwargs.assert_valid_keys(:timeout, :browser_width, :browser_height, :selector, :cookies, :proxy_host, :proxy_port)

      @url = url
      @tempfile = Tempfile.new([DEFAULT_FILE_NAME, DEFAULT_FILE_FORMAT])
      self.cookies = kwargs.delete(:cookies)

      kwargs.each { |key, value| instance_variable_set(:"@#{key}", value) }
    end

    def timeout
      @timeout || DEFAULT_TIMEOUT
    end

    def browser_width
      @browser_width || DEFAULT_BROWSER_WIDTH
    end

    def browser_height
      @browser_height || DEFAULT_BROWSER_HEIGHT
    end

    def capture
      Phantomjs.proxy_host = proxy_host if proxy_host
      Phantomjs.proxy_port = proxy_port if proxy_port

      output = Phantomjs.run(proxy_options, SCRIPT_PATH.to_s, *prepared_params)

      handle_exception(output) if output.present?

      Gastly::Image.new(tempfile)
    end

    private

    def proxy_options
      return '' if proxy_host.blank? && proxy_port.blank?
      "--proxy=#{proxy_host}:#{proxy_port}"
    end

    def prepared_params
      params = {
        url:      url,
        timeout:  timeout,
        width:    browser_width,
        height:   browser_height,
        output:   tempfile.path
      }

      params[:selector] = selector if selector.present?
      params[:cookies]  = hash_to_array(cookies).join(',') if cookies.present?

      hash_to_array(params)
    end

    def hash_to_array(data)
      data.map { |key, value| "#{key}=#{value}" }
    end

    def handle_exception(output)
      error = case output
              when /^FetchError:(.+)/     then Gastly::FetchError
              when /^RuntimeError:(.+)/m  then Gastly::PhantomJSError
              end

      raise error, $1
    end

  end
end