require "active_record"

class Veiculo < ActiveRecord::Base
  has_one :reputation

  attr_accessor  :hora, :lat, :long, :linha

end
