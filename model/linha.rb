require "active_record"

class Linha < ActiveRecord::Base
  has_and_belongs_to_many :paradas

  attr_accessor :codigo, :denominacao, :veiculos, :paradas 

  def merge(linha_strans)
    if linha_strans
      @codigo = linha_strans.codigoLinha
      @denominacao = linha_strans.denominacao
    end
    self
  end
end
