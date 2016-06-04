require "active_record"

class Veiculo < ActiveRecord::Base
  has_one :reputation
end
