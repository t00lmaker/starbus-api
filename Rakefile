require 'yaml'
require 'grape'
require 'envyable'
require 'otr-activerecord'
require 'bundler/setup'

require_relative 'starbus-api'
require_relative 'model/linha'
require_relative 'model/parada'


load 'tasks/otr-activerecord.rake'

# Carrega as variaveis de ambiente no arquivo env.yml
# conforme o ambiente passado no segundo parametro.
CONFIG_ENV = 'development'.freeze
Envyable.load('./config/env.yml', CONFIG_ENV)
Envyable.load('./config/env.yml', 'strans')


namespace :db do
  # Some db tasks require your app code to be loaded; they'll expect to find it here
  task :environment do
    if ENV['DATABASE_URL']
      OTR::ActiveRecord.configure_from_url! ENV['DATABASE_URL']
    else
      OTR::ActiveRecord.configure_from_file! 'config/database.yml'
    end
  end
end

namespace :gp do
  desc "Mostra todas as rotas da api."
  task :routes do
    StarBus::API.routes.each do |api|
      method = api.request_method.ljust(10)
      path = api.path
      puts " #{method} - #{path}"
    end
  end
end
