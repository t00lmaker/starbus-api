require "active_record"

class Reputation < ActiveRecord::Base
  has_many :interactions

end
