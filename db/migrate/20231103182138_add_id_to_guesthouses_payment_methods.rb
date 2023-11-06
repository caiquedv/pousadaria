class AddIdToGuesthousesPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    add_column :guesthouses_payment_methods, :id, :primary_key
  end
end
