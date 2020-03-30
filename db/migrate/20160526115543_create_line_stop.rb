# frozen_string_literal: true

class CreateLineStop < ActiveRecord::Migration[6.0]
  def self.up
    create_join_table :lines, :stops
  end

  def self.down
    drop_table :lines_stopss
  end
end
