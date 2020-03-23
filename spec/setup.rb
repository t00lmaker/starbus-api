
require 'otr-activerecord'
require 'rspec'
require 'rack/test'
require 'airborne'
require 'webmock/rspec'

# env default para rspec = test
ENV['RAILS_ENV'] ||= 'test'

Dir.glob(File.join(File.join(File.dirname(__FILE__), ".."), 'starbus-api.rb')).each do |file|
  require file
end

Dir.glob(File.join(File.join(File.dirname(__FILE__), "..", "lib"), "**.rb")).each do |file|
  require file
end

# configure rack
StarBus::API.before{ env['api.tilt.root'] = 'rabl'} 

Airborne.configure do |config|
  config.rack_app = StarBus::API.new
end

# init active-record
OTR::ActiveRecord.configure_from_file! 'config/database.yml'

#load "db/seeds.rb"

require 'helpers'