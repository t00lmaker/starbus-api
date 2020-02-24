class CreateUsers < ActiveRecord::Migration[6.0]
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :hash_pass
      t.string :email
      t.string :url_facebook
      t.string :url_photo
      t.text :id_facebook
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :users
  end
end
