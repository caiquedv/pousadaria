class AddTotalDueForReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :total_due, :decimal, precision: 10, scale: 2
  end
end
