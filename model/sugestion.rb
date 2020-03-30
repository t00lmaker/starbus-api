# frozen_string_literal: true

require "active_record"

class Sugestion < ActiveRecord::Base
  belongs_to :user
end
