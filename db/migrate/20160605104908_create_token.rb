class CreateToken < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.string :hash_id, index: true
      t.integer :validate_to, default: 10
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :tokens
  end
end
