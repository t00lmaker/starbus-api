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

ActiveRecord::Schema.define(version: 2020_02_20_015935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "key"
    t.bigint "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_application_on_user_id"
  end

  create_table "checkins", id: :serial, force: :cascade do |t|
    t.integer "validate_to", default: 10
    t.integer "user_id"
    t.integer "parada_id"
    t.integer "veiculo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parada_id"], name: "index_checkins_on_parada_id"
    t.index ["user_id"], name: "index_checkins_on_user_id"
    t.index ["veiculo_id"], name: "index_checkins_on_veiculo_id"
  end

  create_table "interactions", id: :serial, force: :cascade do |t|
    t.string "type_"
    t.string "evaluation"
    t.text "comment"
    t.integer "reputation_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reputation_id"], name: "index_interactions_on_reputation_id"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "linhas", id: :serial, force: :cascade do |t|
    t.string "codigo"
    t.string "denominacao"
    t.string "retorno"
    t.string "origem"
    t.boolean "circular"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "linhas_paradas", id: false, force: :cascade do |t|
    t.integer "linha_id", null: false
    t.integer "parada_id", null: false
  end

  create_table "paradas", id: :serial, force: :cascade do |t|
    t.string "codigo"
    t.string "denominacao"
    t.text "endereco"
    t.decimal "lat"
    t.decimal "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reputations", id: :serial, force: :cascade do |t|
    t.integer "veiculo_id"
    t.integer "parada_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parada_id"], name: "index_reputations_on_parada_id"
    t.index ["veiculo_id"], name: "index_reputations_on_veiculo_id"
  end

  create_table "snapshots", id: :serial, force: :cascade do |t|
    t.text "value"
    t.datetime "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sugestions", id: :serial, force: :cascade do |t|
    t.text "text"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text"], name: "index_sugestions_on_text"
    t.index ["user_id"], name: "index_sugestions_on_user_id"
  end

  create_table "tokens", id: :serial, force: :cascade do |t|
    t.string "jwt"
    t.integer "validate", default: 10
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jwt"], name: "index_tokens_on_jwt"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "hash_pass"
    t.string "email"
    t.string "url_facebook"
    t.string "url_photo"
    t.text "id_facebook"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "veiculos", id: :serial, force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
