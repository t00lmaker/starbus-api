class CreateReputation < ActiveRecord::Migration[5.0]
  def self.up
    create_table :reputations do |t|
      t.belongs_to :veiculo, index: true
      t.belongs_to :parada, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :reputations
  end
end
