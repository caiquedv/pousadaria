# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_30_125942) do
  create_table "guesthouses", force: :cascade do |t|
    t.string "brand_name"
    t.string "corporate_name"
    t.string "tax_code"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "postal_code"
    t.text "description"
    t.boolean "accepts_pets"
    t.text "usage_policy"
    t.time "check_in"
    t.time "check_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.boolean "active"
    t.index ["user_id"], name: "index_guesthouses_on_user_id"
  end

  create_table "guesthouses_payment_methods", force: :cascade do |t|
    t.integer "guesthouse_id", null: false
    t.integer "payment_method_id", null: false
    t.index ["guesthouse_id"], name: "index_guesthouses_payment_methods_on_guesthouse_id"
    t.index ["payment_method_id"], name: "index_guesthouses_payment_methods_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "room_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "guests_number"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_price", precision: 10, scale: 2
    t.integer "user_id", null: false
    t.string "code"
    t.datetime "checked_in_at"
    t.integer "payment_method_id"
    t.datetime "checked_out_at"
    t.decimal "total_due", precision: 10, scale: 2
    t.index ["payment_method_id"], name: "index_reservations_on_payment_method_id"
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "reservation_id", null: false
    t.integer "rate"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_reviews_on_reservation_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "dimension"
    t.integer "capacity"
    t.float "daily_rate"
    t.boolean "bathroom"
    t.boolean "balcony"
    t.boolean "air_conditioning"
    t.boolean "television"
    t.boolean "closet"
    t.boolean "safe"
    t.boolean "accessibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guesthouse_id", null: false
    t.boolean "active"
    t.index ["guesthouse_id"], name: "index_rooms_on_guesthouse_id"
  end

  create_table "seasonal_rates", force: :cascade do |t|
    t.string "description"
    t.date "start_date"
    t.date "end_date"
    t.decimal "daily_rate", precision: 10, scale: 2
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seasonal_rates_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "social_security_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "guesthouses", "users"
  add_foreign_key "guesthouses_payment_methods", "guesthouses"
  add_foreign_key "guesthouses_payment_methods", "payment_methods"
  add_foreign_key "reservations", "payment_methods"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "reservations", "users"
  add_foreign_key "reviews", "reservations"
  add_foreign_key "rooms", "guesthouses"
  add_foreign_key "seasonal_rates", "rooms"
end
