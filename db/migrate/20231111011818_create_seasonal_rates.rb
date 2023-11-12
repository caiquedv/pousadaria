class CreateSeasonalRates < ActiveRecord::Migration[7.1]
  def change
    create_table :seasonal_rates do |t|
      t.string :description
      t.date :start_date
      t.date :end_date
      t.decimal :daily_rate, precision: 10, scale: 2
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
