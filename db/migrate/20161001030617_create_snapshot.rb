class CreateSnapshots < ActiveRecord::Migration[5.0]
  def self.up
    create_table :snapshots do |t|
      t.text :value
      t.datetime :data
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :snapshots
  end
end
