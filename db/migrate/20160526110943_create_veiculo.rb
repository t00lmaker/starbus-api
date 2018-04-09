class CreateVeiculo < ActiveRecord::Migration[5.0][5.0]
  def self.up
    create_table :veiculos do |t|
      t.string :codigo
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :veiculos
  end
end
