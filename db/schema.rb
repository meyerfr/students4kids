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

ActiveRecord::Schema.define(version: 2020_05_07_084427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.bigint "sitter_id"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "status", default: "available", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sitter_id"], name: "index_availabilities_on_sitter_id"
    t.index ["start_time"], name: "index_availabilities_on_start_time"
    t.index ["status"], name: "index_availabilities_on_status"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "sitter_id"
    t.string "status", default: "pending"
    t.bigint "availability_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_bookings_on_availability_id"
    t.index ["parent_id"], name: "index_bookings_on_parent_id"
    t.index ["sitter_id"], name: "index_bookings_on_sitter_id"
    t.index ["status"], name: "index_bookings_on_status"
  end

  create_table "children", force: :cascade do |t|
    t.string "first_name", null: false
    t.date "dob"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_children_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "dob"
    t.string "phone"
    t.text "bio"
    t.string "role", default: "parent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "address", default: "", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "radius"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name", "last_name"], name: "index_users_on_first_name_and_last_name"
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "availabilities", "users", column: "sitter_id"
  add_foreign_key "bookings", "availabilities"
  add_foreign_key "bookings", "users", column: "parent_id"
  add_foreign_key "bookings", "users", column: "sitter_id"
  add_foreign_key "children", "users", column: "parent_id"
end
