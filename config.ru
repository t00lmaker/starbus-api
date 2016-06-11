
require 'envyable'
require 'active_record'
require './lib/load-config'
require 'rabl'

require File.expand_path('starbus-api', File.dirname(__FILE__))

db_config       = YAML::load(File.open('config/database.yml'))
db_config       = db_config[ENV['database_env']] # carrega as configurações do banco.
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || db_config)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

use Rack::Config do |env|
  env['api.tilt.root'] = 'rabl'
end

Rabl.configure do |config|
  config.replace_nil_values_with_empty_strings = false
  config.exclude_nil_values = true
  config.exclude_empty_values_in_collections = false
end

run StarBus::API
