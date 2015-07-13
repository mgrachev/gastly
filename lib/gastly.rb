require_relative 'gastly/image'
require_relative 'gastly/screenshot'
require_relative 'gastly/version'

module Gastly

  def screenshot(url, **kwargs)
    Screenshot.new(url, **kwargs)
  end

  def capture(url, path)
    screenshot(url).capture.save(path)
  end

  module_function :screenshot, :capture
end