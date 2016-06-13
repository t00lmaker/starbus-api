require 'singleton'
require 'lazy-strans-client'
require 'timerizer'

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
    valids(@buses_by_lines[cod_linha])
  end

  def get(codigo=nil)
    update()
    buses = codigo ? @buses_by_code[codigo] : @buses_by_code.values
    valids(buses)
  end

  def valid?(veiculo)
    hora_as_array = veiculo.hora.split(':')
    hash_h = { hour: hora_as_array[0].to_i, min: hora_as_array[1].to_i }
    time_veic = Time.now.change(hash_h)
    time_veic >= LIMIT_TIME_VEI.ago
  end


  def valids(buses)
    buses.select { |v| valid?(v) }
  end

  def updated?
    @last_update && @last_update >= LIMIT_TIME_UPDATE.ago
  end

  def update
    unless updated?
      @last_update = Time.now
      veiculos = StransAPi.instance.get(:veiculos)
      if(veiculos && !veiculos.is_a?(ErroStrans))
        veiculos.each do |v|
          @buses_by_code[v.codigo] = v
          @buses_by_lines[v.linha.codigo] ||= []
          @buses_by_lines[v.linha.codigo] << v
        end
      end
    end
  end

  def rest
    @buses_by_code = {}
  end

end
