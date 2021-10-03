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

ActiveRecord::Schema.define(version: 2021_01_14_152606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "broker_instruments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "broker_id", null: false
    t.uuid "instrument_id"
    t.string "match"
    t.string "matched_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["broker_id"], name: "index_broker_instruments_on_broker_id"
    t.index ["instrument_id"], name: "index_broker_instruments_on_instrument_id"
  end

  create_table "brokers", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "exchanges", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fund_providers", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "instruments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "product_identifier"
    t.string "details_url"
    t.string "fund_provider_id", null: false
    t.string "description"
    t.string "asset"
    t.string "profit"
    t.string "replication"
    t.float "provision"
    t.string "currency"
    t.string "residence"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fund_provider_id"], name: "index_instruments_on_fund_provider_id"
  end

  create_table "tickers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "isin"
    t.string "ticker"
    t.string "currency"
    t.string "kind"
    t.string "exchange_id", null: false
    t.uuid "instrument_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exchange_id"], name: "index_tickers_on_exchange_id"
    t.index ["instrument_id"], name: "index_tickers_on_instrument_id"
  end

  add_foreign_key "broker_instruments", "brokers"
  add_foreign_key "broker_instruments", "instruments"
  add_foreign_key "instruments", "fund_providers"
  add_foreign_key "tickers", "exchanges"
  add_foreign_key "tickers", "instruments"
end
