require "yaml"
require "grape"
require "./lib/load-config"
require "./starbus-api"
require "./model/linha"
require "./model/parada"
require "grape/activerecord"
require "active_record"


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

#https://github.com/rails/rails/edit/master/activerecord/lib/active_record/railties/databases.rake
#melhorar com base no link acima.
namespace :db do

  db_config       = YAML::load(File.open('config/database.yml'))
  db_config       = ENV['DATABASE_URL'] || db_config[ENV['database_env']] # carrega as configurações do banco.

  desc "Create the database"
  task :create do
    db_config_admin = db_config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config["database"])
    puts "Database #{db_config["database"]} created."
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::Migrator.migrate("db/migrate/")
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

#  task :down => [:environment, :load_config] do
#    version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
#    raise 'VERSION is required - To go down one migration, run db:rollback' unless version
#    ActiveRecord::Migrator.run(:down, ActiveRecord::Tasks::DatabaseTasks.migrations_paths, version)
#    db_namespace['_dump'].invoke
#  end

#  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
#  task :rollback => [:environment, :load_config] do
#    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
#    ActiveRecord::Migrator.rollback(ActiveRecord::Tasks::DatabaseTasks.migrations_paths, step)
#    db_namespace['_dump'].invoke
#  end

  desc "Drop the database"
  task :drop do
    db_config_admin = db_config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(db_config["database"])
    puts "Database #{db_config["database"]}  deleted."
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = "db/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration
  def self.up
  end
  def self.down
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end
