class CreateCheckin < ActiveRecord::Migration[5.0]
  def self.up
    create_table :checkins do |t|
      t.integer :validate_to, default: 10
      t.belongs_to :user, index: true
      t.belongs_to :parada, index: true
      t.belongs_to :veiculo, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :checkins
  end
end
