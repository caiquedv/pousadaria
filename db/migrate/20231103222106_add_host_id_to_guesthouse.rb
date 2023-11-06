class AddHostIdToGuesthouse < ActiveRecord::Migration[7.1]
  def change
    add_reference :guesthouses, :user, null: false, foreign_key: true
  end
end
