# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[6.0]
  def self.up
    create_table :tokens do |t|
      t.string :jwt, index: true
      t.integer :expiration, default: 10
      t.belongs_to :application, index: true
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :tokens
  end
end
