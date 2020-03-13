# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_20_015955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.string "description"
    t.integer "ownner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "index_applications_on_key"
    t.index ["ownner_id"], name: "index_applications_on_ownner_id"
  end

  create_table "applications_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "application_id", null: false
    t.index ["user_id", "application_id"], name: "index_applications_users_on_user_id_and_application_id", unique: true
  end

  create_table "checkins", force: :cascade do |t|
    t.integer "validate_to", default: 10
    t.bigint "user_id"
    t.bigint "stop_id"
    t.bigint "vehicle_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stop_id"], name: "index_checkins_on_stop_id"
    t.index ["user_id"], name: "index_checkins_on_user_id"
    t.index ["vehicle_id"], name: "index_checkins_on_vehicle_id"
  end

  create_table "interactions", force: :cascade do |t|
    t.string "type_"
    t.string "evaluation"
    t.text "comment"
    t.bigint "reputation_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reputation_id"], name: "index_interactions_on_reputation_id"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.string "return"
    t.string "origin"
    t.boolean "circular"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lines_stops", id: false, force: :cascade do |t|
    t.bigint "line_id", null: false
    t.bigint "stop_id", null: false
  end

  create_table "reputations", force: :cascade do |t|
    t.bigint "vehicle_id"
    t.bigint "stop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stop_id"], name: "index_reputations_on_stop_id"
    t.index ["vehicle_id"], name: "index_reputations_on_vehicle_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.text "value"
    t.datetime "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stops", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.text "address"
    t.decimal "lat"
    t.decimal "long"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sugestions", force: :cascade do |t|
    t.text "text"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["text"], name: "index_sugestions_on_text"
    t.index ["user_id"], name: "index_sugestions_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "jwt"
    t.integer "expiration", default: 10
    t.bigint "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_tokens_on_application_id"
    t.index ["jwt"], name: "index_tokens_on_jwt"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_hash"
    t.string "email"
    t.string "url_photo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
