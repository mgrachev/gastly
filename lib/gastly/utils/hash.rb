module Gastly
  module Utils
    class Hash
      attr_reader :hash

      def initialize(hash = {})
        @hash = hash.to_h
      end

      # Validates all keys in a hash match <tt>*valid_keys</tt>, raising
      # +ArgumentError+ on a mismatch.
      #
      # Note that keys are treated differently than HashWithIndifferentAccess,
      # meaning that string and symbol keys will not match.
      #
      #   { name: 'Rob', years: '28' }.assert_valid_keys(:name, :age) # => raises "ArgumentError: Unknown key: :years. Valid keys are: :name, :age"
      #   { name: 'Rob', age: '28' }.assert_valid_keys('name', 'age') # => raises "ArgumentError: Unknown key: :name. Valid keys are: 'name', 'age'"
      #   { name: 'Rob', age: '28' }.assert_valid_keys(:name, :age)   # => passes, raises nothing
      def assert_valid_keys(*valid_keys)
        valid_keys.flatten!
        hash.each_key do |k|
          unless valid_keys.include?(k)
            fail ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{valid_keys.map(&:inspect).join(', ')}")
          end
        end
      end
    end
  end
end
