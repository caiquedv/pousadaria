class ChangeDefaultStatusOnReservations < ActiveRecord::Migration[7.1]
  def change
    change_column_default :reservations, :status, from: 0, to: 1
  end
end
