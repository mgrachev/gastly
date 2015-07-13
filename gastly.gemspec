# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/gastly/version'

Gem::Specification.new do |spec|
  spec.name          = 'gastly'
  spec.version       = Gastly::VERSION
  spec.authors       = ['Mikhail Grachev']
  spec.email         = ['work@mgrachev.com']

  spec.summary       = %q{Create screenshots or previews of web pages using Gastly. Gastly, I choose you!}
  spec.description   = %q{Create screenshots or previews of web pages using Gastly. Under the hood Phantom.js and MiniMagick.}
  spec.homepage      = 'https://github.com/mgrachev/gastly'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'phantomjs_ruby', '~> 2.0'
  spec.add_dependency 'mini_magick', '~> 4.2'
  spec.add_dependency 'activesupport', '>= 3.1'
end
