require 'strans-client'
require './model/line'
require './model/vehicle'


class LoadVehicles

  def init()
    vehicles = StransAPi.instance.get(:vehicles)
    vehicles.each{|v| transform_vehicles(v).save! }
  end

  def transform_vehicles(vehicle_strans)
    vehicle = Vehicle.new(code: vehicle_strans.code)
    vehicle.reputation = Reputation.new
    vehicle
  end

end
