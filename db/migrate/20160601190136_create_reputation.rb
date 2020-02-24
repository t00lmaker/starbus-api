class CreateReputation < ActiveRecord::Migration[6.0]
  def self.up
    create_table :reputations do |t|
      t.belongs_to :vehicle, index: true
      t.belongs_to :stop, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :reputations
  end
end
