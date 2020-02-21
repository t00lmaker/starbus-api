class CreateInteractions < ActiveRecord::Migration[5.0]
  def self.up
    create_table :interactions do |t|
      t.string :type_
      t.string :evaluation
      t.text :comment
      t.belongs_to :reputation, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :interactions
  end
end
