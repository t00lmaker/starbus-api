require "active_record"

class Token < ActiveRecord::Base
  belongs_to :user
end
