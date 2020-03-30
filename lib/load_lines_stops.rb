# frozen_string_literal: true

require "strans-client"
require "./model/line"
require "./model/stop"

class LoadLinesStops
  @@line_attrs = {
    "codigoLinha" => :code,
    "denominacao" => :description,
    "origem" => :origin,
    "circular" => :circular,
    "retorno" => :return,
  }

  @@stops_attrs = {
    "codigoParada" => :code,
    "denominacao" => :description,
    "endereco" => :address,
    "lat" => :lat,
    "long" => :long,
  }

  def init
    @stops = {}
    @strans = StransClient.new(ENV["STRANS_MAIL"], ENV["STRANS_PASS"], ENV["STRANS_KEY"])
    lines = @strans.get(:linhas)
    if lines.is_a?(ErroStrans)
      raise "Strans Api error '#{lines.to_json}'"
    else
      create_lines(lines)
    end
  end

  def create_lines(lines)
    lines.each do |l|
      has_line = Line.find_by_code(l.codigoLinha)
      next if has_line

      line = transform_in_lines(l)
      stops = @strans.get(:paradas_linha, line.code)
      if stops.is_a?(ErroStrans)
        puts "Strans Api error '#{stops.to_json}'"
      else
        stops = transform_in_stops(stops)
        line.stops = stops
      end
      puts line.code
      line.save!
    end
  end

  # Transforma um line do modelo Strans para uma line do modelo starbus.
  def transform_in_lines(linha_strans)
    line_hash = {}
    linha_strans.instance_variables.each do |var|
      attr_name = var.to_s.delete("@")
      attr_name = @@line_attrs[attr_name]
      if attr_name
        line_hash[attr_name] = linha_strans.instance_variable_get(var)
      end
    end
    line_hash = line_hash.except("veiculos")
    line_hash = line_hash.except("paradas")
    Line.new(line_hash)
  end

  def transform_in_stops(parada_strans)
    stop_hash = {}
    stops = []
    parada_strans.each do |p|
      p.instance_variables.each do |var|
        attr_name = var.to_s.delete("@")
        attr_name = @@stops_attrs[attr_name]
        stop_hash[attr_name] = p.instance_variable_get(var) if attr_name
      end
      stop = @stops[p.codigoParada] || Stop.new(stop_hash)
      @stops[p.codigoParada] = stop
      stop.reputation ||= Reputation.new
      stops << stop
    end
    stops
  end
end
