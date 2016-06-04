class CreateInteraction < ActiveRecord::Migration
  def self.up
    create_table :interactions do |t|
      t.string :tipo
      t.string :avaliacao
      t.text :comment
      t.belongs_to :reputation, index: true
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :interactions
  end
end
