class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.integer :dimension
      t.integer :capacity
      t.float :daily_rate
      t.boolean :bathroom
      t.boolean :balcony
      t.boolean :air_conditioning
      t.boolean :television
      t.boolean :closet
      t.boolean :safe
      t.boolean :accessibility

      t.timestamps
    end
  end
end
