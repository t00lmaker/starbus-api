class CreateLinhaParada < ActiveRecord::Migration
  def self.up
    create_join_table :linhas, :paradas 
  end
  def self.down
    drop_table :linhas_paradass
  end
end
