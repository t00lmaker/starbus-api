class CreateUsers < ActiveRecord::Migration[6.0]
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password_hash
      t.string :email
      t.string :url_photo
      t.timestamps null: false
    end
  end
  def self.down
    drop_table :users
  end
end
