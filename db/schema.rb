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

ActiveRecord::Schema.define(version: 20151025091216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "helpers", force: :cascade do |t|
    t.string   "email",                    null: false
    t.float    "lat",                      null: false
    t.float    "long",                     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "score",      default: 100, null: false
  end

  create_table "orga_members", force: :cascade do |t|
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
    t.integer  "organization_id",                     null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "orga_members", ["email"], name: "index_orga_members_on_email", unique: true, using: :btree
  add_index "orga_members", ["reset_password_token"], name: "index_orga_members_on_reset_password_token", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "is_verified", default: false, null: false
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", using: :btree

  create_table "request_statuses", force: :cascade do |t|
    t.integer  "request_id",                 null: false
    t.integer  "helper_id",                  null: false
    t.boolean  "accepted"
    t.boolean  "timeout",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "request_statuses", ["helper_id"], name: "index_request_statuses_on_helper_id", using: :btree
  add_index "request_statuses", ["request_id"], name: "index_request_statuses_on_request_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.integer  "organization_id",          null: false
    t.string   "name",                     null: false
    t.text     "description",              null: false
    t.text     "description_after_accept"
    t.float    "lat",                      null: false
    t.float    "long",                     null: false
    t.integer  "amount",                   null: false
    t.integer  "timeout",                  null: false
    t.datetime "start"
    t.datetime "end"
    t.integer  "range"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "requests", ["lat"], name: "index_requests_on_lat", using: :btree
  add_index "requests", ["long"], name: "index_requests_on_long", using: :btree

  add_foreign_key "orga_members", "organizations", on_delete: :cascade
  add_foreign_key "request_statuses", "helpers", on_delete: :cascade
  add_foreign_key "request_statuses", "requests", on_delete: :cascade
  add_foreign_key "requests", "organizations", on_delete: :cascade
end
