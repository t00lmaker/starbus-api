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

ActiveRecord::Schema.define(version: 20160605104908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checkins", force: :cascade do |t|
    t.integer  "validate_to", default: 10
    t.integer  "user_id"
    t.integer  "parada_id"
    t.integer  "veiculo_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "checkins", ["parada_id"], name: "index_checkins_on_parada_id", using: :btree
  add_index "checkins", ["user_id"], name: "index_checkins_on_user_id", using: :btree
  add_index "checkins", ["veiculo_id"], name: "index_checkins_on_veiculo_id", using: :btree

  create_table "interactions", force: :cascade do |t|
    t.string   "type_"
    t.string   "evaluation"
    t.text     "comment"
    t.integer  "reputation_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "interactions", ["reputation_id"], name: "index_interactions_on_reputation_id", using: :btree
  add_index "interactions", ["user_id"], name: "index_interactions_on_user_id", using: :btree

  create_table "linhas", force: :cascade do |t|
    t.string   "codigo"
    t.string   "denominacao"
    t.string   "retorno"
    t.string   "origem"
    t.boolean  "circular"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "linhas_paradas", id: false, force: :cascade do |t|
    t.integer "linha_id",  null: false
    t.integer "parada_id", null: false
  end

  create_table "paradas", force: :cascade do |t|
    t.string   "codigo"
    t.string   "denominacao"
    t.text     "endereco"
    t.decimal  "lat"
    t.decimal  "long"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reputations", force: :cascade do |t|
    t.integer  "veiculo_id"
    t.integer  "parada_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reputations", ["parada_id"], name: "index_reputations_on_parada_id", using: :btree
  add_index "reputations", ["veiculo_id"], name: "index_reputations_on_veiculo_id", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.string   "hash_id"
    t.integer  "validate_to", default: 10
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "tokens", ["hash_id"], name: "index_tokens_on_hash_id", using: :btree
  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "facebook"
    t.text     "hash_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "veiculos", force: :cascade do |t|
    t.string   "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
