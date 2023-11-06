class AddNotNullToNameInPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    change_column_null :payment_methods, :name, false
  end
end
