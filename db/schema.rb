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

ActiveRecord::Schema.define(version: 20160720022923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "exercise_sets", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "target_repetitions", null: false
    t.integer  "actual_repetitions"
    t.float    "target_weight",      null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.uuid     "exercise_id",        null: false
    t.uuid     "workout_id"
    t.string   "type",               null: false
    t.integer  "target_duration"
    t.integer  "actual_duration"
    t.index ["exercise_id", "workout_id"], name: "index_exercise_sets_on_exercise_id_and_workout_id", using: :btree
    t.index ["exercise_id"], name: "index_exercise_sets_on_exercise_id", using: :btree
  end

  create_table "exercises", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gyms", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "yelp_id"
    t.index ["yelp_id"], name: "index_gyms_on_yelp_id", unique: true, using: :btree
  end

  create_table "locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.index ["locatable_id", "locatable_type"], name: "index_locations_on_locatable_id_and_locatable_type", using: :btree
  end

  create_table "profiles", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",                          null: false
    t.integer  "gender",           default: 0,     null: false
    t.integer  "social_tolerance"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "time_zone",        default: "UTC", null: false
    t.uuid     "gym_id"
    t.index ["gym_id"], name: "index_profiles_on_gym_id", using: :btree
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true, using: :btree
  end

  create_table "programs", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
    t.index ["slug"], name: "index_programs_on_slug", unique: true, using: :btree
  end

  create_table "received_emails", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id"
    t.text     "to"
    t.text     "from"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_received_emails_on_user_id", using: :btree
  end

  create_table "recommendations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "exercise_id", null: false
    t.uuid     "routine_id",  null: false
    t.integer  "sets",        null: false
    t.integer  "repetitions", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "duration"
  end

  create_table "routines", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "program_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_routines_on_program_id", using: :btree
  end

  create_table "user_sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",     null: false
    t.string   "ip"
    t.text     "user_agent"
    t.datetime "accessed_at"
    t.datetime "revoked_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["username", "email"], name: "index_users_on_username_and_email", using: :btree
    t.index ["username"], name: "index_users_on_username", using: :btree
  end

  create_table "workouts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.uuid     "routine_id",  null: false
    t.datetime "occurred_at", null: false
    t.float    "body_weight"
    t.index ["routine_id"], name: "index_workouts_on_routine_id", using: :btree
    t.index ["user_id"], name: "index_workouts_on_user_id", using: :btree
  end

  add_foreign_key "profiles", "gyms"
  add_foreign_key "received_emails", "users"
  add_foreign_key "user_sessions", "users"
end
