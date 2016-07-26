require 'envyable'
require 'active_record'
require 'rabl'

require File.expand_path('starbus-api', File.dirname(__FILE__))
require File.expand_path('starbus-web', File.dirname(__FILE__))

CONFIG_ENV = 'production'

# Carrega as variaveis de ambiente no arquivo env.yml
# conforme o ambiente passado no segundo parametro.
Envyable.load('./config/env.yml', CONFIG_ENV)
Envyable.load('./config/env.yml', 'strans')

# Configura o banco de dados,caso não encontre valor para ENV ["DATABASE_URL"] (heroku)
# ele carrega a configuração do ambiente do arquivo env.yml.
db_config       = YAML::load(File.open('config/database.yml'))
puts db_config
puts "----------"
puts db_config[ENV['database_env']]

db_config       = ENV["DATABASE_URL"] || db_config[ENV['database_env']]
ActiveRecord::Base.establish_connection(db_config)
use ActiveRecord::ConnectionAdapters::ConnectionManagement

use Rack::Config do |env|
  env['api.tilt.root'] = 'rabl'
end

Rabl.configure do |config|
  config.replace_nil_values_with_empty_strings = false
  config.exclude_nil_values = true
  config.exclude_empty_values_in_collections = false
end

run Rack::URLMap.new("/" => StarBus::Web.new,
                     "/api" => StarBus::API)
#run StarBus::API
