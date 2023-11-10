class AddGuesthouseIdToRoom < ActiveRecord::Migration[7.1]
  def change
    add_reference :rooms, :guesthouse, null: false, foreign_key: true
  end
end
