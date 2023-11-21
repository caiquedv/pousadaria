class ChangePaymentMethodIdToReservations < ActiveRecord::Migration[7.1]
  def change
    change_column :reservations, :payment_method_id, :integer, null: true
  end
end
