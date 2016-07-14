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

ActiveRecord::Schema.define(version: 20160714024634) do

  create_table "charities", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "stripe_id"
    t.string   "email"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "status"
  end

  create_table "charity_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "charity_id"
    t.integer  "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "charity_users", ["charity_id"], name: "index_charity_users_on_charity_id"
  add_index "charity_users", ["user_id"], name: "index_charity_users_on_user_id"

  create_table "donation_charges", force: :cascade do |t|
    t.string   "payment_reference"
    t.integer  "charity_id"
    t.integer  "donation_amount"
    t.integer  "revenue"
    t.integer  "status"
    t.integer  "donation_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "customer_id"
    t.integer  "user_id"
  end

  add_index "donation_charges", ["charity_id"], name: "index_donation_charges_on_charity_id"
  add_index "donation_charges", ["donation_id"], name: "index_donation_charges_on_donation_id"
  add_index "donation_charges", ["user_id"], name: "index_donation_charges_on_user_id"

  create_table "donations", force: :cascade do |t|
    t.string   "payment_reference"
    t.integer  "charity_id"
    t.integer  "donation_amount"
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "donations", ["charity_id"], name: "index_donations_on_charity_id"
  add_index "donations", ["user_id"], name: "index_donations_on_user_id"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "city"
    t.integer  "zip_code"
    t.string   "state"
    t.datetime "end_time"
    t.datetime "start_time"
    t.boolean  "published"
    t.integer  "total_donated"
    t.integer  "total_sales"
    t.integer  "revenue_donation_percent"
    t.integer  "status"
    t.string   "event_image_url"
    t.integer  "user_id"
    t.string   "organizer_name"
    t.string   "organizer_description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "recipient_email"
    t.string   "status"
    t.integer  "donation_charge_id"
    t.integer  "amount"
    t.string   "secret"
    t.string   "description"
    t.string   "stripe_customer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "invoices", ["donation_charge_id"], name: "index_invoices_on_donation_charge_id"
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id"

  create_table "payola_affiliates", force: :cascade do |t|
    t.string   "code"
    t.string   "email"
    t.integer  "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "percent_off"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "payola_sales", force: :cascade do |t|
    t.string   "email",                limit: 191
    t.string   "guid",                 limit: 191
    t.integer  "product_id"
    t.string   "product_type",         limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.integer  "amount"
    t.integer  "fee_amount"
    t.integer  "coupon_id"
    t.boolean  "opt_in"
    t.integer  "download_count"
    t.integer  "affiliate_id"
    t.text     "customer_address"
    t.text     "business_address"
    t.string   "stripe_customer_id",   limit: 191
    t.string   "currency"
    t.text     "signed_custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type",           limit: 100
  end

  add_index "payola_sales", ["coupon_id"], name: "index_payola_sales_on_coupon_id"
  add_index "payola_sales", ["email"], name: "index_payola_sales_on_email"
  add_index "payola_sales", ["guid"], name: "index_payola_sales_on_guid"
  add_index "payola_sales", ["owner_id", "owner_type"], name: "index_payola_sales_on_owner_id_and_owner_type"
  add_index "payola_sales", ["product_id", "product_type"], name: "index_payola_sales_on_product"
  add_index "payola_sales", ["stripe_customer_id"], name: "index_payola_sales_on_stripe_customer_id"

  create_table "payola_stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_subscriptions", force: :cascade do |t|
    t.string   "plan_type"
    t.integer  "plan_id"
    t.datetime "start"
    t.string   "status"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "stripe_customer_id"
    t.boolean  "cancel_at_period_end"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "canceled_at"
    t.integer  "quantity"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.string   "state"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "amount"
    t.string   "guid",                 limit: 191
    t.string   "stripe_status"
    t.integer  "affiliate_id"
    t.string   "coupon"
    t.text     "signed_custom_fields"
    t.text     "customer_address"
    t.text     "business_address"
    t.integer  "setup_fee"
  end

  add_index "payola_subscriptions", ["guid"], name: "index_payola_subscriptions_on_guid"

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.string   "interval"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "description"
    t.string   "name"
    t.integer  "price"
    t.boolean  "public"
    t.integer  "donation_percent"
    t.string   "image_url"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "require_name"
    t.boolean  "require_gender"
    t.boolean  "special_instructions"
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "purchases", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "buyer_email"
    t.integer  "user_id"
    t.integer  "donation_charge_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "purchases", ["donation_charge_id"], name: "index_purchases_on_donation_charge_id"
  add_index "purchases", ["product_id"], name: "index_purchases_on_product_id"
  add_index "purchases", ["user_id"], name: "index_purchases_on_user_id"

  create_table "sellers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "stripe_id"
    t.string   "email"
    t.string   "city"
    t.string   "state"
    t.string   "password"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ticket_purchases", force: :cascade do |t|
    t.integer  "ticket_id"
    t.string   "payment_reference_url"
    t.string   "buyer_email"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "purchase_id"
    t.integer  "status"
  end

  add_index "ticket_purchases", ["purchase_id"], name: "index_ticket_purchases_on_purchase_id"
  add_index "ticket_purchases", ["ticket_id"], name: "index_ticket_purchases_on_ticket_id"
  add_index "ticket_purchases", ["user_id"], name: "index_ticket_purchases_on_user_id"

  create_table "tickets", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "ticket_name"
    t.integer  "quantity_available"
    t.integer  "price"
    t.string   "description"
    t.datetime "sales_start"
    t.datetime "sales_end"
    t.integer  "ticket_minimum"
    t.integer  "ticket_maximum"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "tickets", ["event_id"], name: "index_tickets_on_event_id"

  create_table "user_invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "invitee"
    t.boolean  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
    t.integer  "plan_id"
    t.string   "publishable_key"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_code"
    t.boolean  "public_profile"
    t.integer  "donation_rate"
    t.string   "name"
    t.string   "website"
    t.string   "description"
    t.string   "business_name"
    t.integer  "transaction_cost"
    t.string   "facebook_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["plan_id"], name: "index_users_on_plan_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
