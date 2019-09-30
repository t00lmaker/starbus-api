require 'active_record'
require_relative 'linha'

class Veiculo < ActiveRecord::Base
  has_one :reputation

  attr_accessor :hora, :lat, :long, :last_lat, :last_long, :linha

  # faz o merge entre dois veiculos.
  def merge(veiculo_strans)
    if veiculo_strans
      @codigo = veiculo_strans.codigoVeiculo
      @hora = veiculo_strans.hora
      @lat  = veiculo_strans.lat
      @long = veiculo_strans.long
      @linha = Linha.new.merge(veiculo_strans.linha)
    end
  end

  def as_json (options=nil)
    attrs = {}
    attrs[:codigo] = @codigo
    attrs[:lat] = @lat
    attrs[:long] = @long
    attrs[:hora] = @hora
    attrs[:linha] = @linha
    attrs
  end

end
