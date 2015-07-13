require 'mini_magick'

module Gastly
  class Image

    attr_reader :file

    def initialize(tempfile)
      @file = MiniMagick::Image.open(tempfile.path, 'png')
      tempfile.unlink
    end

    def resize(width:, height:)
      dimensions = "#{width}x#{height}"
      @file.resize(dimensions)
    end

    def format(ext)
      @file.format(ext)
    end

  end
end