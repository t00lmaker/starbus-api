
require 'envyable'
require "active_record"

require File.expand_path('starbus-api', File.dirname(__FILE__))

Envyable.load('./config/env.yml', 'development')

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run StarBus::API
