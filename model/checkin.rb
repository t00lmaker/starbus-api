require "active_record"

class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :parada
  belongs_to :veiculo
end
