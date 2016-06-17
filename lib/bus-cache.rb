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

  def all()
    update()
    valids(@buses_by_code.values)
  end

  def get(codigo)
    update()
    @buses_by_code[codigo]
  end

  def get_by_line(cod_linha)
    update()
    hash_linhas = @buses_by_lines[cod_linha]
    hash_linhas ||= {}
    valids(hash_linhas.values)
  end

  def updated?
    @last_update && @last_update >= LIMIT_TIME_UPDATE.ago
  end

  private

  def now
    Time.now.utc.localtime("-03:00")
  end

  def valid?(veiculo)
    hora_as_array = veiculo.hora.split(':')
    hash_h = { hour: hora_as_array[0].to_i, min: hora_as_array[1].to_i }
    time_veic = now.change(hash_h)
    time_veic >= LIMIT_TIME_VEI.ago
  end

  def valids(buses)
    buses.select { |v| valid?(v) } if buses
  end

  def update
    unless updated?
      @last_update = now
      veiculos = StransAPi.instance.get(:veiculos)
      if(veiculos && !veiculos.is_a?(ErroStrans))
        veiculos.each do |veiculo_strans|
          veiculo = load_or_save(veiculo_strans)
          @buses_by_code[veiculo.codigo] = veiculo
          @buses_by_lines[veiculo.linha.codigo] ||= {}
          @buses_by_lines[veiculo.linha.codigo][veiculo.codigo] = veiculo
        end
      end
    end
  end

  def load_or_save(veiculo_strans)
    codigo = veiculo_strans.codigo
    veiculo = Veiculo.find_by_codigo(codigo)
    unless(veiculo)
      veiculo = Veiculo.new(codigo: codigo)
      veiculo.reputation = Reputation.new
    end
    veiculo.merge(veiculo_strans)
    veiculo.save unless veiculo.persisted?
    veiculo
  end

end
