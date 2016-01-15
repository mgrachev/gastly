require 'mini_magick'

module Gastly
  class Image
    attr_reader :file

    # @param tempfile [Tempfile] Screenshot
    def initialize(tempfile)
      @file = MiniMagick::Image.open(tempfile.path)
      tempfile.unlink
    end

    # @param [Hash]
    # @option width [Fixnum] Image width
    # @option height [Fixnum] Image height
    def resize(width:, height:)
      dimensions = "#{width}x#{height}"
      @file.resize(dimensions)
    end

    # @param ext [String] Image extension
    # @return [MiniMagick::Image] Instance
    def format(ext)
      @file.format(ext)
    end

    # @param output [String] Full path to file
    # @return [String] Full path to file
    def save(output)
      @file.write(output)
      output
    end
  end
end
