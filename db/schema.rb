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

ActiveRecord::Schema.define(version: 20150525182105) do

  create_table "access_ip_addresses", force: :cascade do |t|
    t.string   "access_ip_address", limit: 32,                 null: false
    t.integer  "access_count",      limit: 4,  default: 1
    t.string   "user_id",           limit: 36
    t.string   "access_key",        limit: 36
    t.boolean  "access_flagged",    limit: 1,  default: false
    t.string   "access_flag_code",  limit: 3
    t.boolean  "access_blacklist",  limit: 1,  default: false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "admin_auth_tokens", force: :cascade do |t|
    t.string   "auth_token_id",      limit: 36, null: false
    t.string   "admin_id",           limit: 36, null: false
    t.datetime "auth_token_expires",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "user_id",             limit: 36,                 null: false
    t.string   "admin_id",            limit: 36,                 null: false
    t.boolean  "admin_active",        limit: 1,  default: false
    t.string   "created_by_admin_id", limit: 36
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.string   "auth_token_id",      limit: 36, null: false
    t.string   "user_id",            limit: 36, null: false
    t.datetime "auth_token_expires",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "user_id",      limit: 36,  null: false
    t.string   "company_id",   limit: 36,  null: false
    t.string   "company_name", limit: 256
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade do |t|
    t.string   "user_id",       limit: 36,  null: false
    t.string   "email_id",      limit: 36,  null: false
    t.string   "email_address", limit: 128, null: false
    t.string   "reset_key",     limit: 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passwords", force: :cascade do |t|
    t.string   "user_id",            limit: 36,  null: false
    t.string   "password_id",        limit: 36,  null: false
    t.string   "encrypted_password", limit: 256, null: false
    t.string   "reset_key",          limit: 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "review_id",       limit: 36,                null: false
    t.string   "truck_id",        limit: 36,                null: false
    t.string   "company_id",      limit: 36,                null: false
    t.string   "user_id",         limit: 36
    t.float    "review_score",    limit: 24
    t.text     "review_text",     limit: 65535
    t.integer  "review_type",     limit: 4
    t.integer  "trucker_is_read", limit: 4,     default: 0
    t.integer  "company_is_read", limit: 4,     default: 0
    t.text     "decision_tree",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucks", force: :cascade do |t|
    t.string   "user_id",             limit: 36, null: false
    t.string   "company_id",          limit: 36, null: false
    t.string   "truck_id",            limit: 36, null: false
    t.string   "truck_code",          limit: 36
    t.string   "truck_license_plate", limit: 36
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_id",                 limit: 36,                  null: false
    t.string   "company_id",              limit: 36
    t.string   "user_username",           limit: 64,                  null: false
    t.string   "user_first_name",         limit: 64
    t.string   "user_last_name",          limit: 64
    t.string   "user_middle_name",        limit: 64
    t.datetime "user_date_of_birth"
    t.string   "user_company_name",       limit: 256
    t.boolean  "user_verified",           limit: 1,   default: false
    t.string   "user_account_type",       limit: 32,                  null: false
    t.string   "verification_key",        limit: 36
    t.datetime "verification_expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
