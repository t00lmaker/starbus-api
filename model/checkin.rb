# frozen_string_literal: true

require "active_record"

class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :stop
  belongs_to :vehicle
end
