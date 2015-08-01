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

ActiveRecord::Schema.define(version: 20150616021904) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "exercise_sessions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "training_session_id",              null: false
    t.uuid     "exercise_workout_id",              null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "sets",                default: [],              array: true
    t.float    "target_weight"
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

  create_table "profiles", force: :cascade do |t|
    t.uuid     "user_id",                      null: false
    t.integer  "gender",           default: 0
    t.integer  "social_tolerance", default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "programs", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  add_index "programs", ["slug"], name: "index_programs_on_slug", unique: true, using: :btree

  create_table "training_sessions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.uuid     "workout_id",  null: false
    t.datetime "occurred_at", null: false
    t.float    "body_weight"
  end

  add_index "training_sessions", ["user_id"], name: "index_training_sessions_on_user_id", using: :btree

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

end
