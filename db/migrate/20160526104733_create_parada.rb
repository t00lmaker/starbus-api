
class CreateParada < ActiveRecord::Migration[5.0][5.0]
  def self.up
    create_table :paradas do |t|
      t.string :codigo
      t.string :denominacao
      t.text :endereco
      t.decimal :lat
      t.decimal :long
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :paradas
  end
end
