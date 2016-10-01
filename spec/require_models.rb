require 'rspec'
require 'rack/test'
require 'airborne'

Dir.glob(File.join(File.join(File.dirname(__FILE__), ".."), 'starbus-api.rb')).each do |file|
  require file
end

Dir.glob(File.join(File.join(File.dirname(__FILE__), "..", "lib"), "**.rb")).each do |file|
  require file
end

Airborne.configure do |config|
  config.rack_app = StarBus::API.new
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
