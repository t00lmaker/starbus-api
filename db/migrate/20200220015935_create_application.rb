class CreateApplication < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :description
      t.string :key
      t.belongs_to :user, index: true
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
