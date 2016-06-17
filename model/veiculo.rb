require "active_record"

class Veiculo < ActiveRecord::Base
  has_one :reputation

  attr_accessor  :hora, :lat, :long, :linha

  # faz o merge entre dois veiculos.
  def merge(veiculo_strans)
    if(veiculo_strans)
      @hora = veiculo_strans.hora
      @lat  = veiculo_strans.lat
      @long = veiculo_strans.long
      @linha = veiculo_strans.linha
    end
  end

end
