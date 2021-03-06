require File.join(File.dirname(__FILE__), '..', 'jobbed.rb')

require 'sinatra'
require 'rack/test'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def jobbed
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
