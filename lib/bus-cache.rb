require 'singleton'
require 'lazy-strans-client'
require 'timerizer'
require './model/veiculo'
require './model/snapshot'


# Essa classe deve atualizar um cache
# da posicao de todos os onibus, retornando
# ultima posição nos ultimos 3 minutos.
class BusCache
  include Singleton

  LIMIT_TIME_UPDATE = 20.seconds
  LIMIT_TIME_VEI  = 5.minute
  LIMIT_TIME_SAVE = 1.minute

  def initialize
    @client = StransClient.new(ENV['email'],ENV['senha'],ENV['key'])
  end

  def all()
    update()
    valids(@buses_by_code.values)
  end

  def get(codigo)
    update()
    valid?(@buses_by_code[codigo]) ? @buses_by_code[codigo] : nil
  end

  def get_by_line(cod_linha)
    update()
    veiculos = StransAPi.instance.get(:veiculos_linha, cod_linha)
    load_in_map(veiculos)
    veiculos = @buses_by_line[cod_linha]
    veiculos ? valids(veiculos.values) : nil
  end

  def updated?
    @last_update && @last_update >= LIMIT_TIME_UPDATE.ago
  end

  private

  def now
    Time.now.utc.localtime("-03:00")
  end

  def valid?(veiculo)
    if (veiculo)
      hora_as_array = veiculo.hora.split(':')
      hash_h = { hour: hora_as_array[0].to_i, min: hora_as_array[1].to_i }
      time_veic = now.change(hash_h)
      puts "#{veiculo.codigo} = #{hash_h} = #{ time_veic >= LIMIT_TIME_VEI.ago}"
      return time_veic >= LIMIT_TIME_VEI.ago && time_veic <= LIMIT_TIME_VEI.from_now
    end
    false
  end

  def valids(buses)
    buses.select { |v| valid?(v) } if buses
  end

  def update
    unless updated?
      reset() if(!@last_update || @last_update.day != now.day)
      @last_update = now
      veiculos = StransAPi.instance.get(:veiculos)
      load_in_map(veiculos)
    end
    save_snapshot
  end

  def load_in_map(veiculos_strans)
    veiculos_update = []
    if(veiculos_strans && !veiculos_strans.is_a?(ErroStrans))
      veiculos_strans.each do |veiculo_strans|
        if(valid?(veiculo_strans))
          veiculo = load_or_save(veiculo_strans)
          veiculos_update << veiculo
          @buses_by_code[veiculo.codigo] = veiculo
          @buses_by_line[veiculo.linha.codigo] ||= {}
          @buses_by_line[veiculo.linha.codigo][veiculo.codigo] = veiculo
        end
      end
    end
    veiculos_update
  end

  def load_or_save(veiculo_strans)
    codigo = veiculo_strans.codigo
    veiculo = Veiculo.find_by_codigo(codigo)
    unless(veiculo)
      veiculo = Veiculo.new(codigo: codigo)
      veiculo.reputation = Reputation.new
    end
    veiculo.merge(veiculo_strans)
    load_last_position(veiculo)
    veiculo.save unless veiculo.persisted?
    veiculo
  end

  def load_last_position(veiculo)
    last_veiculo = @buses_by_code[veiculo.codigo]
    if(last_veiculo)
      if(last_veiculo.lat == veiculo.lat && last_veiculo.long == veiculo.long)
        veiculo.last_lat = last_veiculo.last_lat
        veiculo.last_long = last_veiculo.last_long
      else
        veiculo.last_lat = last_veiculo.lat
        veiculo.last_long = last_veiculo.long
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
      Snapshot.create({value: @buses_by_line.to_json})
      @last_save = now
    end
  end

end
