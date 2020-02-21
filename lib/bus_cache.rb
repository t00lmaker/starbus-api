require 'singleton'
require 'lazy-strans-client'
require 'timerizer'
require_relative '../model/vehicle'
require_relative '../model/snapshot'
require_relative '../model/line'


# Essa classe deve atualizar um cache
# da posicao de todos os onibus, retornando
# ultima posicao nos ultimos 3 minutos.
class BusCache
  include Singleton

  LIMIT_TIME_UPDATE = 20.seconds
  LIMIT_TIME_VEI  = 5.minute
  LIMIT_TIME_SAVE = 5.minute

  def initialize
    @client = StransClient.new(ENV['email'],ENV['senha'],ENV['key'])
  end

  def all
    update
    valids(@buses_by_code.values)
  end

  def get(code)
    update
    valid?(@buses_by_code[code]) ? @buses_by_code[code] : nil
  end

  def get_by_line(cod_line)
    update
    vehicles = StransAPi.instance.get(:vehicles_line, cod_line)
    load_in_map(vehicles)
    vehicles = @buses_by_line[cod_line]
    vehicles ? valids(vehicles.values) : nil
  end

  def updated?
    @last_update && @last_update >= LIMIT_TIME_UPDATE.ago
  end

  private

  def now
    Time.now.utc.localtime("-03:00")
  end

  # valida por meio do horario vehicles strans e starbus.
  def valid?(vehicle)
    if vehicle
      hora_as_array = vehicle.hora.split(':')
      hash_h = { hour: hora_as_array[0].to_i, min: hora_as_array[1].to_i }
      time_veic = now.change(hash_h)
      return time_veic >= LIMIT_TIME_VEI.ago && time_veic <= LIMIT_TIME_VEI.from_now
    end
    false
  end

  def valids(buses)
    buses.select { |v| valid?(v) } if buses
  end

  def update
    unless updated?
      reset if(!@last_update || @last_update.day != now.day)
      @last_update = now
      vehicles = StransAPi.instance.get(:vehicles)
      load_in_map(vehicles)
    end
    save_snapshot
  end

  def load_in_map(vehicles_strans)
    vehicles_update = []
    if vehicles_strans && !vehicles_strans.is_a?(ErroStrans)
      vehicles_strans.each do |vehicle_strans|
        next unless valid?(vehicle_strans)
        vehicle = load_or_save(vehicle_strans)
        vehicles_update << vehicle
        @buses_by_code[vehicle.code] = vehicle
        @buses_by_line[vehicle.line.code] ||= {}
        @buses_by_line[vehicle.line.code][vehicle.code] = vehicle
      end
    end
    vehicles_update
  end

  def load_or_save(vehicle_strans)
    code = vehicle_strans.codeVehicle
    vehicle = Vehicle.find_by_code(code)
    unless vehicle 
      vehicle = Vehicle.create(code: code, reputation: Reputation.new)
    end
    vehicle.merge(vehicle_strans)
    load_last_position(vehicle)
    vehicle
  end

  def load_last_position(vehicle)
    last_vehicle = @buses_by_code[vehicle.code]
    if last_vehicle
      if last_vehicle.lat == vehicle.lat && last_vehicle.long == vehicle.long
        vehicle.last_lat = last_vehicle.last_lat
        vehicle.last_long = last_vehicle.last_long
      else
        vehicle.last_lat = last_vehicle.lat
        vehicle.last_long = last_vehicle.long
      end
    end
  end

  def reset
    @buses_by_code = {}
    @buses_by_line = {}
    @last_update = nil
  end

  def save_snapshot
    unless(@last_save && @last_save > LIMIT_TIME_SAVE.ago)
      lines_buses = {}
      @buses_by_line.each do |k,v|
        lines_buses[k] = v.values
      end
      Snapshot.create({value: lines_buses.to_json, data: Time.now - 3.hours})
      @last_save = now
    end
  end
end
