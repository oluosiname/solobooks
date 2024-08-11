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

ActiveRecord::Schema[7.1].define(version: 2024_08_11_060858) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "business_name"
    t.string "business_tax_id"
    t.string "vat_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "user_id"], name: "index_clients_on_email_and_user_id", unique: true
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "symbol", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false, null: false
    t.index ["active"], name: "index_currencies_on_active"
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "financial_transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "date", null: false
    t.string "transaction_type", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_type"], name: "index_financial_transactions_on_transaction_type"
    t.index ["user_id"], name: "index_financial_transactions_on_user_id"
  end

  create_table "invoice_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_invoice_categories_on_name", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.decimal "total_amount", precision: 10, scale: 2
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invoice_category_id", null: false
    t.string "vat_id"
    t.string "invoice_number"
    t.string "tax_id"
    t.decimal "vat", precision: 10, scale: 2
    t.decimal "vat_rate", precision: 5, scale: 2, default: "0.0"
    t.boolean "vat_included", default: false, null: false
    t.bigint "currency_id"
    t.string "language"
    t.decimal "subtotal", precision: 10, scale: 2
    t.bigint "client_id", null: false
    t.string "vat_technique", default: "exempt", null: false
    t.date "due_date"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["currency_id"], name: "index_invoices_on_currency_id"
    t.index ["date"], name: "index_invoices_on_date"
    t.index ["invoice_category_id"], name: "index_invoices_on_invoice_category_id"
    t.index ["invoice_number", "user_id"], name: "index_invoices_on_invoice_number_and_user_id", unique: true
    t.index ["status"], name: "index_invoices_on_status"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "description"
    t.integer "quantity", default: 1, null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
  end

  create_table "payment_details", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "bank_name"
    t.string "iban"
    t.string "swift"
    t.string "account_number"
    t.string "sort_code"
    t.string "routing_number"
    t.string "account_holder"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_details_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "legal_status", null: false
    t.string "full_name", null: false
    t.string "phone_number"
    t.date "date_of_birth"
    t.string "nationality"
    t.string "country"
    t.string "business_name"
    t.string "tax_number"
    t.string "vat_id"
    t.bigint "currency_id"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_profiles_on_currency_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "language"
    t.string "currency"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_settings_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clients", "users"
  add_foreign_key "financial_transactions", "users"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "currencies"
  add_foreign_key "invoices", "invoice_categories"
  add_foreign_key "invoices", "users"
  add_foreign_key "line_items", "invoices"
  add_foreign_key "payment_details", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "settings", "profiles"
end
