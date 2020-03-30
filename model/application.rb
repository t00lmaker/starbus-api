# frozen_string_literal: true

class Application < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :ownner, class_name: "User", foreign_key: "ownner_id"
end
