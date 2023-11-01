class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[6.0] # ou a versão do ActiveRecord que você estiver usando
  def change
    change_column :users, :role, :integer, default: 0
  end
end
