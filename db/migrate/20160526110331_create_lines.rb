class CreateLines < ActiveRecord::Migration[6.0]
  def self.up
    create_table :lines do |t|
      t.string :code
      t.string :description
      t.string :return
      t.string :origin
      t.boolean :circular
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :lines
  end
end
