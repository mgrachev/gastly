require 'mini_magick'

module Gastly
  class Image

    attr_reader :file

    def initialize(tempfile)
      @file = MiniMagick::Image.open(tempfile.path, 'png')
      tempfile.unlink
    end

  end
end