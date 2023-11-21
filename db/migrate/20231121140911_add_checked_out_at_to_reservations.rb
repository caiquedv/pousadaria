class AddCheckedOutAtToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :checked_out_at, :datetime
  end
end
