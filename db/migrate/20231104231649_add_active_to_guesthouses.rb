class AddActiveToGuesthouses < ActiveRecord::Migration[7.1]
  def change
    add_column :guesthouses, :active, :boolean
  end
end
