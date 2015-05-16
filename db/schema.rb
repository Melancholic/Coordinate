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

ActiveRecord::Schema.define(version: 20150504083818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "api_tokens", force: :cascade do |t|
    t.integer  "car_id"
    t.string   "token",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "api_tokens", ["car_id"], name: "index_api_tokens_on_car_id", using: :btree

  create_table "cars", force: :cascade do |t|
    t.string   "title",                                     null: false
    t.string   "description"
    t.integer  "user_id",                                   null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "tracker_uuid"
    t.string   "color",                  default: "FF0000", null: false
    t.integer  "priority",     limit: 2, default: 5,        null: false
    t.integer  "image_id"
  end

  add_index "cars", ["title", "user_id"], name: "index_cars_on_title_and_user_id", unique: true, using: :btree
  add_index "cars", ["tracker_uuid"], name: "index_cars_on_tracker_uuid", unique: true, using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "address"
    t.float    "latitude",                        null: false
    t.float    "longitude",                       null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "state",      default: "Location", null: false
    t.float    "accuracy"
    t.float    "speed"
    t.datetime "time"
    t.integer  "track_id"
    t.float    "distance"
  end

  add_index "locations", ["track_id", "latitude", "longitude", "time"], name: "track_id_lat_long_time_index", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "image_id"
    t.string   "name"
    t.string   "second_name"
    t.string   "middle_name"
    t.string   "mobile_phone"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "reset_passwords", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "password_key", null: false
    t.string   "host"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "reset_passwords", ["user_id"], name: "index_reset_passwords_on_user_id", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "stop_time"
    t.integer  "car_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                                       null: false
    t.string   "email",                                       null: false
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "admin",                       default: false
    t.string   "auth_hash"
    t.string   "time_zone",       limit: 255, default: "UTC"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "users_mails", force: :cascade do |t|
    t.string   "first_name",                             null: false
    t.string   "last_name"
    t.string   "email",                                  null: false
    t.string   "subject",                                null: false
    t.string   "message",    limit: 1000,                null: false
    t.boolean  "opened",                  default: true
    t.integer  "user_id"
    t.string   "host",       limit: 15
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "verification_users", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "verification_key"
    t.boolean  "verificated"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
