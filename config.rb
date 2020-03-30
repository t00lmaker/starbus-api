# frozen_string_literal: true

require "rack"
require "envyable"
require "rabl"
require "grape"
require "otr-activerecord"
require_relative "starbus-api"

CONFIG_ENV = ENV["RACK_ENV"] || "development"

Rabl.configure do |config|
  config.replace_nil_values_with_empty_strings = false
  config.exclude_nil_values = true
  config.exclude_empty_values_in_collections = false
end

OTR::ActiveRecord.configure_from_file! "config/database.yml"

app = Rack::Builder.new do
  use Rack::Config do |env| env["api.tilt.root"] = "rabl" end
  use OTR::ActiveRecord::ConnectionManagement
  run StarBus::API.new
end.to_app

Rack::Handler::WEBrick.run(app, Port: 9292)
