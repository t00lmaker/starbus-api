class CreateLineStop < ActiveRecord::Migration[5.0]
  def self.up
    create_join_table :lines, :stops 
  end
  def self.down
    drop_table :lines_stopss
  end
end
