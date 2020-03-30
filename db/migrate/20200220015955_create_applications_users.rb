# frozen_string_literal: true

class CreateApplicationsUsers < ActiveRecord::Migration[6.0]
  def self.up
    create_join_table :users, :applications do |t|
      t.index %i[user_id application_id], unique: true
    end
  end

  def self.down
    drop_table :users_applications
  end
end
