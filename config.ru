
require 'envyable'
require "active_record"

require File.expand_path('starbus-api', File.dirname(__FILE__))

Envyable.load('./config/env.yml', 'development')
Envyable.load('./config/env.yml', 'strans')


db_config       = YAML::load(File.open('config/database.yml'))
db_config       = db_config[ENV['database_env']] # carrega as configurações do banco.
ActiveRecord::Base.establish_connection(db_config)

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run StarBus::API
