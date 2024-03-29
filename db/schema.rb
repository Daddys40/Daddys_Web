# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141115064330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: true do |t|
    t.integer  "user_id",                         null: false
    t.text     "title"
    t.text     "content"
    t.integer  "week"
    t.integer  "resources_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "readed",          default: false
  end

  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree
  add_index "cards", ["week"], name: "index_cards_on_week", using: :btree

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id",    null: false
    t.text     "text"
    t.boolean  "checked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role"
    t.string   "gender"
    t.string   "baby_name"
    t.integer  "age"
    t.integer  "height"
    t.float    "weight"
    t.datetime "baby_due"
    t.string   "authentication_token"
    t.string   "invitation_code"
    t.integer  "partner_id"
    t.string   "notifications_days"
    t.time     "notificate_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_code"], name: "index_users_on_invitation_code", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
