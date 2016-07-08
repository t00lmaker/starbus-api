require "active_record"

class Sugestion < ActiveRecord::Base
  belongs_to :user
end
