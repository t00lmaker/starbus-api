require 'envyable'
require 'rabl'
require 'grape'
require 'otr-activerecord'
require_relative 'starbus-api'
require_relative 'starbus-web'

CONFIG_ENV = 'development'

# Carrega as variaveis de ambiente no arquivo env.yml
# conforme o ambiente passado no segundo parametro.
Envyable.load('./config/env.yml', CONFIG_ENV)
Envyable.load('./config/env.yml', 'strans')

# Configura o banco de dados,caso não encontre valor para ENV ["DATABASE_URL"] (heroku)
# ele carrega a configuração do ambiente do arquivo env.yml.
#db_config       = YAML::load(File.open('config/database.yml'))

#puts "Url database = #{ENV["DATABASE_URL"]}"
#puts "Configuration Env. = #{db_config[ENV['database_env']]}"

#db_config = db_config[ENV['database_env']]

use Rack::Config do |env|
  env['api.tilt.root'] = 'rabl'
end

Rabl.configure do |config|
  config.replace_nil_values_with_empty_strings = false
  config.exclude_nil_values = true
  config.exclude_empty_values_in_collections = false
end

if ENV['DATABASE_URL']
  OTR::ActiveRecord.configure_from_url! ENV['DATABASE_URL']
else
  OTR::ActiveRecord.configure_from_file! 'config/database.yml'
end

use OTR::ActiveRecord::ConnectionManagement

run Rack::URLMap.new('/' => StarBus::Web.new,
                     '/api' => StarBus::API)
