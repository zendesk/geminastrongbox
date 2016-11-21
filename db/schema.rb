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

ActiveRecord::Schema.define(version: 20161119231012) do

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "identifier"
    t.string   "password_digest"
    t.datetime "used_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["identifier"], name: "index_devices_on_identifier", unique: true

  create_table "uploaders", force: true do |t|
    t.string   "gem_name",    null: false
    t.string   "gem_version", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
  end

  add_index "uploaders", ["gem_name", "gem_version"], name: "index_uploaders_on_gem_name_and_gem_version", unique: true
  add_index "uploaders", ["user_id"], name: "index_uploaders_on_user_id"

  create_table "users", force: true do |t|
    t.string   "external_id"
    t.string   "name"
    t.string   "email"
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["external_id"], name: "index_users_on_external_id", unique: true

end
