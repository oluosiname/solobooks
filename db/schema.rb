# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 2024_03_18_190539) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'currencies', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'code', null: false
    t.string 'symbol', null: false
    t.boolean 'active', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'default', default: false
    t.index ['active'], name: 'index_currencies_on_active'
    t.index ['code'], name: 'index_currencies_on_code', unique: true
  end

  create_table 'invoice_categories', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_invoice_categories_on_name', unique: true
  end

  create_table 'invoices', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.date 'date'
    t.date 'due_date'
    t.decimal 'total_amount', precision: 10, scale: 2
    t.string 'status', default: 'pending'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'invoice_category_id', null: false
    t.string 'vat_id'
    t.string 'invoice_number'
    t.string 'tax_id'
    t.decimal 'vat', precision: 5, scale: 2
    t.decimal 'vat_rate', precision: 5, scale: 2, default: '0.0'
    t.boolean 'vat_included', default: false
    t.bigint 'currency_id'
    t.string 'language'
    t.decimal 'subtotal', precision: 10, scale: 2
    t.index ['currency_id'], name: 'index_invoices_on_currency_id'
    t.index ['date'], name: 'index_invoices_on_date'
    t.index ['due_date'], name: 'index_invoices_on_due_date'
    t.index ['invoice_category_id'], name: 'index_invoices_on_invoice_category_id'
    t.index ['invoice_number'], name: 'index_invoices_on_invoice_number', unique: true
    t.index ['status'], name: 'index_invoices_on_status'
    t.index ['user_id'], name: 'index_invoices_on_user_id'
  end

  create_table 'line_items', force: :cascade do |t|
    t.bigint 'invoice_id', null: false
    t.string 'description'
    t.integer 'quantity', default: 1, null: false
    t.decimal 'unit_price', precision: 10, scale: 2, default: '0.0'
    t.decimal 'total_price', precision: 10, scale: 2, default: '0.0'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'unit'
    t.index ['invoice_id'], name: 'index_line_items_on_invoice_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'invoices', 'currencies'
  add_foreign_key 'invoices', 'invoice_categories'
  add_foreign_key 'invoices', 'users'
  add_foreign_key 'line_items', 'invoices'
end
