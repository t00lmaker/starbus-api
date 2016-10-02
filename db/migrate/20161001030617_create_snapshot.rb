class CreateSnapshot < ActiveRecord::Migration
  def self.up
    create_table :snapshots do |t|
      t.text :value
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :snapshots
  end
end
