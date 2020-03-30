# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[6.0]
  def self.up
    create_table :vehicles do |t|
      t.string :code
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :vehicles
  end
end
