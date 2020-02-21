require 'strans-client'
require './model/line'
require './model/stop'

class LoadLinesStops

  def init
    @stops = {}
    @strans = StransClient.new(ENV['STRANS_MAIL'], ENV['STRANS_PASS'],ENV['STRANS_KEY'])
    lines = @strans.get(:lines)
    if(lines.is_a?(ErroStrans))
      raise RuntimeError, "Strans Api error '#{lines.to_json}'"
    else 
      create_lines(lines)
    end
  end

  def create_lines(lines)
    lines.each do |l|
      has_line = Line.find_by_code(l.codeLine)
      unless(has_line)
        line = transform_in_lines(l)
        stops = @strans.get(:stops_line, line.code)
        if(stops.is_a?(ErroStrans))
          puts "Strans Api error '#{stops.to_json}'"
        else
          stops = transform_in_stops(stops)
          line.stops = stops              
        end
        puts line.code
        line.save!
      end
    end
  end

  #Transforma um line do modelo Strans para uma
  #line do modelo starbus.
  def transform_in_lines(line_strans)
    line_hash = {}
    line_strans.instance_variables.each do |var|
      attr_name = var.to_s.delete("@")
      attr_name = :code if attr_name == 'codeLine'
      attr_name = :denominacao if attr_name == 'denomicao'
      line_hash[attr_name] = line_strans.instance_variable_get(var)
    end
    line_hash = line_hash.except("vehicles")
    line_hash = line_hash.except("stops")
    Line.new(line_hash)
  end

  def transform_in_stops(stops_strans)
    stop_hash = {}
    stops = []
    stops_strans.each do |p|
      p.instance_variables.each do |var|
        attr_name = var.to_s.delete("@")
        attr_name = :code if attr_name == 'codeStop'
        attr_name = :denominacao if attr_name == 'denomicao'
        stop_hash[attr_name] = p.instance_variable_get(var)
      end
      stop_hash = stop_hash.except("line")
      stop = @stops[p.codeStop] || Stop.new(stop_hash)
      @stops[p.codeStop] = stop
      stop.reputation ||= Reputation.new
      stops << stop
    end
    stops
  end

end
