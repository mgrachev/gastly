# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gastly/version'

Gem::Specification.new do |spec|
  spec.name          = 'gastly'
  spec.version       = Gastly::VERSION
  spec.authors       = ['Mikhail Grachev']
  spec.email         = ['work@mgrachev.com']

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
end
