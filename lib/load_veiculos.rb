require 'strans-client'
require './model/linha'
require './model/veiculo'


class LoadVeiculos

  def init()
    veiculos = StransAPi.instance.get(:veiculos)
    veiculos.each{|v| transform_veiculos(v).save! }
  end

  def transform_veiculos(veiculo_strans)
    veiculo = Veiculo.new(codigo: veiculo_strans.codigo)
    veiculo.reputation = Reputation.new
    veiculo
  end

end
