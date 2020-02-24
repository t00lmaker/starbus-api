class CreateToken < ActiveRecord::Migration[6.0]
  def self.up
    create_table :tokens do |t|
      t.string :jwt, index: true
      t.integer :validate, default: 10
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :tokens
  end
end
