# frozen_string_literal: true

source "https://rubygems.org"

# A simple DSL to easily develop RESTful APIs.
gem "grape"

# Adapter Postgres Ruby
gem "pg"

# Load variables in config/env.yml in ENV (variavel de ambiente).
gem "envyable"

# Load Tasks para migratons from ActiveRecord.
# gem 'standalone_migrations'

# cliente da api da strans.
gem "strans-client"

# database lib
gem "otr-activerecord"

# json templates
gem "grape-rabl"

# time lib
gem "timerizer"

# Gem para cryptografia
gem "bcrypt"

# basic lib
gem "rake"

# Auth with jwt
gem "jwt"

group :development do
  gem "coveralls", require: false
  gem "debase"
  gem "rubocop", require: false
  gem "ruby-debug-ide"
  gem "rufo", require: false
end

group :test do
  # basic lib
  gem "rspec"
  # Mock Requests. https://github.com/bblimke/webmock
  gem "webmock"
  # teste para web apis https://github.com/brooklynDev/airborne
  gem "airborne"
end
