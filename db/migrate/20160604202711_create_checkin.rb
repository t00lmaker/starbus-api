class CreateCheckins < ActiveRecord::Migration[5.0]
  def self.up
    create_table :checkins do |t|
      t.integer :validate_to, default: 10
      t.belongs_to :user, index: true
      t.belongs_to :stop, index: true
      t.belongs_to :vehicle, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :checkins
  end
end
