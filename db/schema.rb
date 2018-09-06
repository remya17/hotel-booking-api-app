# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180907083109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.integer  "user_id",                                                                     null: false
    t.integer  "room_id",                                                                     null: false
    t.date     "move_in_date",                                                                null: false
    t.date     "move_out_date",                                                               null: false
    t.decimal  "monthly_rent",                       precision: 12, scale: 2, default: "0.0", null: false
    t.string   "payment_transaction_id", limit: 200
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.index ["move_in_date"], name: "index_bookings_on_move_in_date", using: :btree
    t.index ["move_out_date"], name: "index_bookings_on_move_out_date", using: :btree
    t.index ["room_id"], name: "index_bookings_on_room_id", using: :btree
    t.index ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end

  create_table "hotel_room_type_rates", force: :cascade do |t|
    t.integer  "hotel_room_type_id",                                          null: false
    t.date     "start_date",                                                  null: false
    t.date     "end_date",                                                    null: false
    t.decimal  "rate",               precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.index ["end_date"], name: "index_hotel_room_type_rates_on_end_date", using: :btree
    t.index ["hotel_room_type_id"], name: "index_hotel_room_type_rates_on_hotel_room_type_id", using: :btree
    t.index ["start_date"], name: "index_hotel_room_type_rates_on_start_date", using: :btree
  end

  create_table "hotel_room_types", force: :cascade do |t|
    t.integer  "hotel_id",                 null: false
    t.integer  "room_type_id",             null: false
    t.integer  "total_rooms",  default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["hotel_id", "room_type_id"], name: "index_hotel_room_types_on_hotel_id_and_room_type_id", unique: true, using: :btree
    t.index ["hotel_id"], name: "index_hotel_room_types_on_hotel_id", using: :btree
    t.index ["room_type_id"], name: "index_hotel_room_types_on_room_type_id", using: :btree
  end

  create_table "hotels", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.string   "location"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "room_types", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description"
    t.integer  "occupancy_limit", default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "hotel_room_type_id", null: false
    t.string   "name",               null: false
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["hotel_room_type_id"], name: "index_rooms_on_hotel_room_type_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",      limit: 200, null: false
    t.string   "first_name", limit: 200, null: false
    t.string   "last_name",  limit: 200, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
