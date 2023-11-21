class AddCheckedInAtToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :checked_in_at, :datetime
  end
end
