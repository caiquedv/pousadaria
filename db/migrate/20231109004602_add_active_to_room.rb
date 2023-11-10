class AddActiveToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :active, :boolean
  end
end
