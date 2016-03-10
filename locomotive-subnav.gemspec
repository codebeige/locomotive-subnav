# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locomotive/subnav/version'

Gem::Specification.new do |spec|
  spec.name          = "locomotive-subnav"
  spec.version       = Locomotive::Subnav::VERSION
  spec.authors       = ["Tibor Claassen"]
  spec.email         = ["tibor@gmah.net"]

  spec.summary       = %q{Navigate current section}
  spec.description   = %q(Provides Liquid tags for rendering breadcrumbs and
                          subnavigation of a LocomotiveCMS site.
                       ).gsub(/^\s*/, '')
  spec.homepage      = "https://github.com/codebeige/locomotive-subnav"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
                         f.match(%r{^(test|spec|features)/})
                       end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "locomotivecms_steam", "~> 1.0.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.7.1"
end
