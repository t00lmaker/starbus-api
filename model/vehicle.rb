require 'active_record'
require_relative 'line'

class Vehicle < ActiveRecord::Base
  has_one :reputation

  attr_accessor :time, :lat, :long, :last_lat, :last_long, :line

  # faz o merge entre dois vehicles.
  def merge(vehicle_strans)
    if vehicle_strans
      @code = vehicle_strans.codigoVeiculo
      @time = vehicle_strans.hora
      @lat  = vehicle_strans.lat
      @long = vehicle_strans.long
      @line = Line.new.merge(vehicle_strans.linha)
    end
  end

  def as_json (options=nil)
    attrs = {}
    attrs[:code] = @code
    attrs[:lat] = @lat
    attrs[:long] = @long
    attrs[:time] = @hora
    attrs[:line] = @line
    attrs
  end

end
