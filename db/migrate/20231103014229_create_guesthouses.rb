class CreateGuesthouses < ActiveRecord::Migration[7.1]
  def change
    create_table :guesthouses do |t|
      t.string :brand_name
      t.string :corporate_name
      t.string :tax_code
      t.string :phone
      t.string :email
      t.string :address
      t.string :district
      t.string :state
      t.string :city
      t.string :postal_code
      t.text :description
      t.boolean :accepts_pets
      t.text :usage_policy
      t.time :check_in
      t.time :check_out

      t.timestamps
    end
  end
end
