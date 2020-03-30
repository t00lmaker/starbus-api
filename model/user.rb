# frozen_string_literal: true

require "bcrypt"

class User < ActiveRecord::Base
  has_and_belongs_to_many :applications
  has_many :your_apps, class_name: "Application", foreign_key: "ownner_id"

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
