#!/usr/bin/env ruby

require 'irb'
require 'otr-activerecord'
require_relative '../starbus-api'

## Esse arquivo permite que rode a aplicação no console irb.

# Carrega as configurações do Active Record
OTR::ActiveRecord.configure_from_file! 'config/database.yml'

# Starta o irb
IRB.start

