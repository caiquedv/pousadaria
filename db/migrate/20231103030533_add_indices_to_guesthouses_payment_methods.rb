class AddIndicesToGuesthousesPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    add_index :guesthouses_payment_methods, :guesthouse_id
    add_index :guesthouses_payment_methods, :payment_method_id
    add_foreign_key :guesthouses_payment_methods, :guesthouses
    add_foreign_key :guesthouses_payment_methods, :payment_methods
  end
end
