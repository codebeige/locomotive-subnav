# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locomotive/subtree/version'

Gem::Specification.new do |spec|
  spec.name          = "locomotive-subtree"
  spec.version       = Locomotive::Subtree::VERSION
  spec.authors       = ["Tibor Claassen"]
  spec.email         = ["tibor@gmah.net"]

  spec.summary       = %q{Navigate current subtree}
  spec.description   = %q(Provides a Liquid tag for rendering a navigation of
                          the current subtree of a LocomotiveCMS site.
                       ).gsub(/^\s*/, '')
  spec.homepage      = "https://github.com/codebeige/locomotive-subtree"
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
