#!/usr/bin/env ruby

require 'irb'
require 'otr-activerecord'
require_relative '../starbus-api'

OTR::ActiveRecord.configure_from_file! 'config/database.yml'

IRB.start

