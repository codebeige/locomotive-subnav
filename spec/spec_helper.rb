$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'locomotive/subtree'

Locomotive::Steam.configure do |config|
  config.mode = :test
end

require 'rspec-html-matchers'
RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
