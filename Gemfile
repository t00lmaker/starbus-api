
source "https://rubygems.org"

# A simple DSL to easily develop RESTful APIs.
gem 'grape'

# A framework MOR Ruby (The Best)
gem 'activerecord'

# Adapter Postgres Ruby
gem 'pg'

# Load variables in config/env.yml in ENV (variavel de ambiente).
gem 'envyable'

# Load Tasks para migratons from ActiveRecord.
#gem 'standalone_migrations'

#cliente da api da strans.
gem 'strans-client', '1.5.0.pre.RC'

#Ajuda a gerenciar conexoes com banco.
#https://github.com/jhollinger/grape-activerecord
gem "grape-activerecord"

#https://github.com/ruby-grape/grape-rabl
gem 'grape-rabl'

group :development do
  # Debug code Ruby require 'pry' and binding.pry
  # for define breakpoint.
  gem 'pry'
end

group :test do
  gem 'rspec'

  # Mock Requests. https://github.com/bblimke/webmock
  gem 'webmock'

  # Record your test suite's HTTP interactions. https://github.com/vcr/vcr
  gem 'vcr'

end
