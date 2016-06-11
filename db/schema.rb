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

ActiveRecord::Schema.define(version: 20160611152357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "exercise_sessions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "training_session_id",              null: false
    t.uuid     "exercise_workout_id",              null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "actual_sets",         default: [],              array: true
    t.float    "target_weight"
    t.integer  "target_sets",         default: 5,  null: false
    t.integer  "target_repetitions",  default: 5,  null: false
  end

  create_table "exercise_workouts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "exercise_id", null: false
    t.uuid     "workout_id",  null: false
    t.integer  "sets",        null: false
    t.integer  "repetitions", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "exercises", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gyms", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "yelp_id"
  end

  add_index "gyms", ["yelp_id"], name: "index_gyms_on_yelp_id", unique: true, using: :btree

  create_table "locations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "locatable_id"
    t.string   "locatable_type"
    t.decimal  "latitude",       precision: 10, scale: 6
    t.decimal  "longitude",      precision: 10, scale: 6
    t.string   "address"
    t.string   "city"
    t.string   "region"
    t.string   "country"
    t.string   "postal_code"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "locations", ["locatable_id", "locatable_type"], name: "index_locations_on_locatable_id_and_locatable_type", using: :btree

  create_table "profiles", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",                          null: false
    t.integer  "gender"
    t.integer  "social_tolerance"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "time_zone",        default: "UTC", null: false
    t.uuid     "gym_id"
  end

  add_index "profiles", ["gym_id"], name: "index_profiles_on_gym_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", unique: true, using: :btree

  create_table "programs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  add_index "programs", ["slug"], name: "index_programs_on_slug", unique: true, using: :btree

  create_table "received_emails", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id"
    t.text     "to"
    t.text     "from"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "received_emails", ["user_id"], name: "index_received_emails_on_user_id", using: :btree

  create_table "training_sessions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.uuid     "workout_id",  null: false
    t.datetime "occurred_at", null: false
    t.float    "body_weight"
  end

  add_index "training_sessions", ["user_id"], name: "index_training_sessions_on_user_id", using: :btree

  create_table "user_sessions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",     null: false
    t.string   "ip"
    t.text     "user_agent"
    t.datetime "accessed_at"
    t.datetime "revoked_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "workouts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "program_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "profiles", "gyms"
  add_foreign_key "received_emails", "users"
  add_foreign_key "user_sessions", "users"
end
