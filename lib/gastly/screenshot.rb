module Gastly
  class Screenshot
    SCRIPT_PATH = File.expand_path('../script.js', __FILE__)
    DEFAULT_TIMEOUT = 0
    DEFAULT_BROWSER_WIDTH = 1440
    DEFAULT_BROWSER_HEIGHT = 900
    DEFAULT_FILE_FORMAT = '.png'.freeze

    attr_reader :image
    attr_writer :timeout, :browser_width, :browser_height
    attr_accessor :url, :selector, :cookies, :proxy_host, :proxy_port, :phantomjs_options

    # @param url [String] The full url to the site
    def initialize(url, **kwargs)
      hash = Gastly::Utils::Hash.new(kwargs)
      hash.assert_valid_keys(:timeout, :browser_width, :browser_height, :selector, :cookies, :proxy_host, :proxy_port, :phantomjs_options)

      @url = url
      @cookies = kwargs.delete(:cookies)

      @image = MiniMagick::Image.create(DEFAULT_FILE_FORMAT, false) # Disable validation

      kwargs.each { |key, value| instance_variable_set(:"@#{key}", value) }
    end

    # Capture image via PhantomJS and save to output file
    #
    # @return [Gastly::Image] Instance of Gastly::Image
    def capture
      # This necessary to install PhantomJS via proxy
      Phantomjs.proxy_host = proxy_host if proxy_host
      Phantomjs.proxy_port = proxy_port if proxy_port

      output = Phantomjs.run(options, SCRIPT_PATH.to_s, *prepared_params)
      handle_output(output)

      Gastly::Image.new(image)
    end

    %w(timeout browser_width browser_height).each do |name|
      define_method name do                                 # def timeout
        instance_variable_get("@#{name}") ||                #   @timeout ||
          self.class.const_get("default_#{name}".upcase)    #     self.class.const_get('DEFAULT_TIMEOUT')
      end                                                   # end
    end

    private

    def options
      [proxy_options, phantomjs_options].join(' ').strip
    end

    def proxy_options
      return '' if proxy_host.nil? && proxy_port.nil?
      "--proxy=#{proxy_host}:#{proxy_port}"
    end

    def prepared_params
      params = {
        url:      url,
        timeout:  timeout,
        width:    browser_width,
        height:   browser_height,
        output:   image.path
      }

      params[:selector] = selector if selector
      params[:cookies]  = parameterize(cookies).join(',') if cookies

      parameterize(params)
    end

    # @param hash [Hash]
    # @return [Array] Array of parameterized strings
    def parameterize(hash)
      hash.map { |key, value| "#{key}=#{value}" }
    end

    def handle_output(out)
      output = Gastly::Utils::String.new(out)
      return unless output.present?

      error = case output.string
              when /^FetchError:(.+)/     then Gastly::FetchError
              when /^RuntimeError:(.+)/m  then Gastly::PhantomJSError
              else UnknownError
              end

      fail error, Regexp.last_match(1)
    end
  end
end
