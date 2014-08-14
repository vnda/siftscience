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

ActiveRecord::Schema.define(version: 20140814162907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shops", force: true do |t|
    t.string "sift_api_key",                 null: false
    t.string "vnda_api_host",                null: false
    t.string "vnda_api_user",                null: false
    t.string "vnda_api_password",            null: false
    t.string "token",             limit: 32, null: false
  end

  add_index "shops", ["token"], name: "index_shops_on_token", unique: true, using: :btree
  add_index "shops", ["vnda_api_host"], name: "index_shops_on_vnda_api_host", unique: true, using: :btree

end
