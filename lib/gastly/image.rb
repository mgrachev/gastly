module Gastly
  class Image
    attr_reader :image

    # @param image [MiniMagick::Image] Instance of MiniMagick::Image
    def initialize(image)
      @image = image
    end

    # @param width [Fixnum] Image width
    # @param height [Fixnum] Image height
    def resize(width:, height:)
      dimensions = "#{width}x#{height}"
      image.resize(dimensions)
    end

    # @param width [Fixnum] Crop width
    # @param height [Fixnum] Crop height
    # @param x [Fixnum] Crop x offset
    # @param y [Fixnum] Crop y offset
    def crop(width:, height:, x:, y:)
      dimensions = "#{width}x#{height}+#{x}+#{y}"
      image.crop(dimensions)
    end

    # @param ext [String] Image extension
    # @return [MiniMagick::Image] Instance
    def format(ext)
      image.format(ext)
    end

    # @param output [String] Full path to image
    # @return [String] Full path to image
    def save(output)
      image.write(output)
      output
    end
  end
end
