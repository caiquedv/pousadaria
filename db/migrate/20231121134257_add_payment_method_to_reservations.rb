class AddPaymentMethodToReservations < ActiveRecord::Migration[7.1]
  def change
    add_reference :reservations, :payment_method, null: false, foreign_key: true
  end
end
