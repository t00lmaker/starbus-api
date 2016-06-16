require 'singleton'
require 'lazy-strans-client'
require 'timerizer'
require './model/veiculo'


# Essa classe deve atualizar um cache
# da posicao de todos os onibus, retornando
# ultima posição nos ultimos 3 minutos.
class BusCache
  include Singleton

  LIMIT_TIME_UPDATE = 20.seconds
  LIMIT_TIME_VEI = 5.minute

  def initialize
    @buses_by_code = {}
    @buses_by_lines = {}
    @client = StransClient.new(ENV['email'],ENV['senha'],ENV['key'])
  end

  def get_by_line(cod_linha)
    update()
    valids(@buses_by_lines[cod_linha]||[])
  end

  def get(codigo=nil)
    update()
    buses = codigo ? @buses_by_code[codigo] : @buses_by_code.values
    valids(buses || [])
  end

  def valid?(veiculo)
    hora_as_array = veiculo.hora.split(':')
    hash_h = { hour: hora_as_array[0].to_i, min: hora_as_array[1].to_i }
    time_veic = now.change(hash_h)
    time_veic >= LIMIT_TIME_VEI.ago
  end

  def merge(veiculo)
    veiculos = get(veiculo.codigo)
    if(veiculos.first)
      veiculo_strans = veiculos.first
      veiculo.hora = veiculo_strans.hora
      veiculo.lat  = veiculo_strans.lat
      veiculo.long = veiculo_strans.long
      veiculo.linha = veiculo_strans.linha
    end
    veiculo
  end


  def valids(buses)
    buses.select { |v| valid?(v) }
  end

  def updated?
    @last_update && @last_update >= LIMIT_TIME_UPDATE.ago
  end

  def update
    unless updated?
      @last_update = now
      veiculos = StransAPi.instance.get(:veiculos)
      if(veiculos && !veiculos.is_a?(ErroStrans))
        veiculos.each do |v|
          @buses_by_code[v.codigo] = v
          @buses_by_lines[v.linha.codigo] ||= []
          @buses_by_lines[v.linha.codigo].delete_if{ |e| e.codigo == v.codigo }
          @buses_by_lines[v.linha.codigo] << v
        end
        update_db()
      end
    end
  end

  def rest
    @buses_by_code = {}
  end

  def now
    Time.now.utc.localtime("-03:00")
  end

  private

  def update_db
    @buses_by_code.keys.each do |codigo|
      veiculo = Veiculo.find_by_codigo(codigo)
      if(!veiculo)
        veiculo = Veiculo.new(codigo: codigo)
        veiculo.reputation = Reputation.new
        veiculo.save
      end
    end
  end

end
