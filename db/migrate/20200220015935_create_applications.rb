class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :key, index: true
      t.string :description
      t.integer :ownner_id, index: true
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end