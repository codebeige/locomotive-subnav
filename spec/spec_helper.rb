$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'locomotive/subnav'

Locomotive::Steam.configure do |config|
  config.mode = :test
end

require 'rspec-html-matchers'
RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end

require_relative 'support/template_context'
