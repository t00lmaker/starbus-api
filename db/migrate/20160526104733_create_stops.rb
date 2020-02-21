
class CreateStops < ActiveRecord::Migration[6.0]
  def self.up
    create_table :stops do |t|
      t.string :code
      t.string :description
      t.text :andress
      t.decimal :lat
      t.decimal :long
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :stops
  end
end
