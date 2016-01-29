$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gastly'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |config|
  config.before(:suite) do
    Phantomjs.implode!
    Phantomjs.path
  end
end
