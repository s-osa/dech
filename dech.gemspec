# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dech/version'

Gem::Specification.new do |spec|
  spec.name          = "dech"
  spec.version       = Dech::VERSION
  spec.authors       = ["OSA Shunsuke"]
  spec.email         = ["hhelibebcnofnenamg@gmail.com"]
  spec.summary       = %q{Utilities gem for e-commerce mall in Japan.}
  spec.description   = %q{Dech enables you to upload price change easily.}
  spec.homepage      = "https://github.com/e-maido/dech"
  spec.license       = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
