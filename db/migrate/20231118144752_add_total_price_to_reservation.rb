class AddTotalPriceToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :total_price, :decimal, precision: 10, scale: 2
  end
end
