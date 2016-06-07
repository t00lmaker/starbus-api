class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :facebook
      t.text :hash_id
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :users
  end
end
