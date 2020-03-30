# frozen_string_literal: true

require "active_record"

class Stop < ActiveRecord::Base
  has_and_belongs_to_many :lines, -> { order "code ASC" }
  has_one :reputation

  attr_accessor :dist
end
