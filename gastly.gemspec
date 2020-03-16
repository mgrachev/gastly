# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gastly/version'

Gem::Specification.new do |spec|
  spec.name          = 'gastly'
  spec.version       = Gastly::VERSION
  spec.authors       = ['Mikhail Grachev']
  spec.email         = ['work@mgrachev.com']

  spec.summary       = 'Create screenshots or previews of web pages using Gastly. Gastly, I choose you!'
  spec.description   = 'Create screenshots or previews of web pages using Gastly. Under the hood Phantom.js and MiniMagick.'
  spec.homepage      = 'https://github.com/mgrachev/gastly'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec', '~> 3.4.0'

  spec.add_dependency 'phantomjs', '~> 2.1.1'
  spec.add_dependency 'mini_magick', '~> 4.2'
end
