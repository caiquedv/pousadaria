class AddSocialSecurityNumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :social_security_number, :string
  end
end
