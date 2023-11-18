class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :room, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :guests_number
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
