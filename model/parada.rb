require "active_record"

class Parada < ActiveRecord::Base

  has_and_belongs_to_many :linhas , -> { order "codigo ASC" }
  has_one :reputation

  attr_accessor :dist


end
