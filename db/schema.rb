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

ActiveRecord::Schema.define(version: 20150623213526) do

  create_table "plan_has_workouts", force: :cascade do |t|
    t.integer  "workout_id"
    t.integer  "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_has_workouts", ["plan_id"], name: "index_plan_has_workouts_on_plan_id"
  add_index "plan_has_workouts", ["workout_id"], name: "index_plan_has_workouts_on_workout_id"

  create_table "plan_types", force: :cascade do |t|
    t.integer  "order"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "plan_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "plans", ["plan_type_id"], name: "index_plans_on_plan_type_id"

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "email"
    t.integer  "user_id"
  end

  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id"

  create_table "training_cycles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "race_date"
    t.integer  "experience_type_id"
    t.integer  "mileage_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "calendar_id"
  end

  add_index "training_cycles", ["experience_type_id"], name: "index_training_cycles_on_experience_type_id"
  add_index "training_cycles", ["mileage_type_id"], name: "index_training_cycles_on_mileage_type_id"
  add_index "training_cycles", ["plan_id"], name: "index_training_cycles_on_plan_id"
  add_index "training_cycles", ["user_id"], name: "index_training_cycles_on_user_id"

  create_table "user_workouts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "workout_type_id"
    t.date     "workout_date"
    t.integer  "rating"
    t.string   "weather"
    t.string   "feeling"
    t.text     "description"
    t.integer  "total_mileage"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "details"
    t.integer  "training_cycle_id"
  end

  add_index "user_workouts", ["training_cycle_id"], name: "index_user_workouts_on_training_cycle_id"
  add_index "user_workouts", ["user_id"], name: "index_user_workouts_on_user_id"
  add_index "user_workouts", ["workout_type_id"], name: "index_user_workouts_on_workout_type_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "encrypted_password"
    t.string   "salt"
  end

  create_table "workout_types", force: :cascade do |t|
    t.integer  "order"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "workouts", force: :cascade do |t|
    t.integer  "plan_day"
    t.integer  "week_day"
    t.string   "description"
    t.integer  "workout_type_id"
    t.integer  "mileage"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "total_mileage"
  end

  add_index "workouts", ["workout_type_id"], name: "index_workouts_on_workout_type_id"

end
