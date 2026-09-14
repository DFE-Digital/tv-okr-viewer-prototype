# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_26_151232) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "activity", null: false
    t.datetime "created_at", null: false
    t.string "delivery_link"
    t.string "depends_on"
    t.integer "end_sprint"
    t.bigint "key_result_id", null: false
    t.bigint "key_result_workstream_id"
    t.string "schedule_basis"
    t.integer "start_sprint"
    t.string "status", default: "Not started", null: false
    t.datetime "updated_at", null: false
    t.string "workstream", null: false
    t.index ["key_result_id"], name: "index_activities_on_key_result_id"
    t.index ["key_result_workstream_id"], name: "index_activities_on_key_result_workstream_id"
  end

  create_table "key_result_workstreams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "key_result_id", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "workstream_id", null: false
    t.index ["key_result_id", "workstream_id"], name: "index_kr_workstreams_on_kr_and_workstream", unique: true
    t.index ["key_result_id"], name: "index_key_result_workstreams_on_key_result_id"
    t.index ["workstream_id"], name: "index_key_result_workstreams_on_workstream_id"
  end

  create_table "key_results", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.bigint "objective_id", null: false
    t.integer "position", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["objective_id"], name: "index_key_results_on_objective_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workstreams", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "colour", default: "#738096", null: false
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_workstreams_on_title", unique: true
  end

  add_foreign_key "activities", "key_result_workstreams"
  add_foreign_key "activities", "key_results"
  add_foreign_key "key_result_workstreams", "key_results"
  add_foreign_key "key_result_workstreams", "workstreams"
  add_foreign_key "key_results", "objectives"
end
