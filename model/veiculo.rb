require "active_record"

class Veiculo < ActiveRecord::Base
  has_one :reputation

  attr_accessor  :hora, :lat, :long, :last_lat, :last_long, :linha

  # faz o merge entre dois veiculos.
  def merge(veiculo_strans)
    if(veiculo_strans)
      @hora = veiculo_strans.hora
      @lat  = veiculo_strans.lat
      @long = veiculo_strans.long
      @linha = veiculo_strans.linha
    end
  end

  def as_json (options=nil)
    attrs = {}
    attrs[:codigo] = self.codigo if self.codigo
    attrs[:lat] = @lat if @lat
    attrs[:long] = @long if @long
    attrs[:hora] = @hora if @hora
    attrs
  end

end
