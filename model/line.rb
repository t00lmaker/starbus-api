require "active_record"

class Line < ActiveRecord::Base
  has_and_belongs_to_many :stops

  attr_accessor :vehicles 

  def merge(line_strans)
    if line_strans
      self.code = line_strans.codeLine
      self.denominacao = line_strans.denominacao
    end
    self
  end
end
