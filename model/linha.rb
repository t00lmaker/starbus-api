require "active_record"

class Linha < ActiveRecord::Base
  has_and_belongs_to_many :paradas

  attr_accessor :veiculos 

  def merge(linha_strans)
    if linha_strans
      self.codigo = linha_strans.codigoLinha
      self.denominacao = linha_strans.denominacao
    end
    self
  end
end
