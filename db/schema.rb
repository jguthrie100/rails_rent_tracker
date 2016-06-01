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

ActiveRecord::Schema.define(version: 20160531123204) do

  create_table "properties", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "address",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "archived",   default: false, null: false
  end

  create_table "property_snapshots", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "num_bedrooms"
    t.decimal  "weekly_rent",  precision: 10, scale: 2
    t.decimal  "agency_fees",  precision: 10, scale: 2
    t.integer  "property_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "property_snapshots", ["property_id"], name: "index_property_snapshots_on_property_id"

  create_table "snapshot_joins", force: :cascade do |t|
    t.integer  "property_snapshot_id", null: false
    t.integer  "tenant_snapshot_id",   null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "snapshot_joins", ["property_snapshot_id"], name: "index_snapshot_joins_on_property_snapshot_id"
  add_index "snapshot_joins", ["tenant_snapshot_id"], name: "index_snapshot_joins_on_tenant_snapshot_id"

  create_table "tenant_snapshots", force: :cascade do |t|
    t.date     "start_date",                               null: false
    t.date     "end_date"
    t.decimal  "weekly_rent",     precision: 10, scale: 2, null: false
    t.integer  "rent_frequency",                           null: false
    t.integer  "tenant_id",                                null: false
    t.integer  "rent_paid_by_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "tenant_snapshots", ["rent_paid_by_id"], name: "index_tenant_snapshots_on_rent_paid_by_id"
  add_index "tenant_snapshots", ["tenant_id"], name: "index_tenant_snapshots_on_tenant_id"

  create_table "tenants", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "payment_handle"
    t.string   "phone_num"
    t.string   "email"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "archived",       default: false, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "bank_account_id",                             null: false
    t.date     "date",                                        null: false
    t.string   "transaction_id",                              null: false
    t.string   "transaction_type"
    t.string   "cheque_num"
    t.string   "payee"
    t.string   "memo"
    t.decimal  "amount",             precision: 10, scale: 2, null: false
    t.integer  "tenant_snapshot_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "transactions", ["bank_account_id"], name: "index_transactions_on_bank_account_id"
  add_index "transactions", ["tenant_snapshot_id"], name: "index_transactions_on_tenant_snapshot_id"
  add_index "transactions", ["transaction_id"], name: "index_transactions_on_transaction_id"

end
