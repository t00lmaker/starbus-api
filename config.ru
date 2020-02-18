require 'envyable'
require 'rabl'
require 'grape'
require 'otr-activerecord'
require_relative 'starbus-api'
require_relative 'starbus-web'

CONFIG_ENV = ENV['RACK_ENV']

use Rack::Config do |env|
  env['api.tilt.root'] = 'rabl'
end

Rabl.configure do |config|
  config.replace_nil_values_with_empty_strings = false
  config.exclude_nil_values = true
  config.exclude_empty_values_in_collections = false
end

OTR::ActiveRecord.configure_from_file! 'config/database.yml'

use OTR::ActiveRecord::ConnectionManagement

run Rack::URLMap.new('/' => StarBus::Web.new,
                     '/api' => StarBus::API)
