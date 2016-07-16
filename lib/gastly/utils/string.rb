module Gastly
  module Utils
    class String
      BLANK_RE = /\A[[:space:]]*\z/

      attr_reader :string

      def initialize(string = '')
        @string = string.to_s
      end

      # A string is blank if it's empty or contains whitespaces only:
      #
      #   ''.blank?       # => true
      #   '   '.blank?    # => true
      #   "\t\n\r".blank? # => true
      #   ' blah '.blank? # => false
      #
      # Unicode whitespace is supported:
      #
      #   "\u00a0".blank? # => true
      #
      # @return [true, false]
      def blank?
        BLANK_RE === string
      end

      # An object is present if it's not blank.
      #
      # @return [true, false]
      def present?
        !blank?
      end
    end
  end
end
