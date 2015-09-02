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

ActiveRecord::Schema.define(version: 20150901093431) do

  create_table "groups", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true

  create_table "logs", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "message_code"
    t.string   "message_type"
    t.string   "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "code",         null: false
    t.string   "product_id",   null: false
    t.string   "secret_token", null: false
    t.integer  "product_type", null: false
    t.text     "schedule"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "products", ["code"], name: "index_products_on_code", unique: true
  add_index "products", ["product_id"], name: "index_products_on_product_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",              null: false
    t.string   "encrypted_password", null: false
    t.string   "salt"
    t.text     "options"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
