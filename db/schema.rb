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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130309193905) do

  create_table "companies", :force => true do |t|
    t.integer  "company_linkedin_id"
    t.string   "company_linkedin_name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "companies_linkedinusers", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "linkedinuser_id"
  end

  create_table "connections_linkedinusers", :id => false, :force => true do |t|
    t.integer  "linkedinuser_id"
    t.integer  "connection_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "linkedin_oauth_settings", :force => true do |t|
    t.string   "atoken"
    t.string   "asecret"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "linkedinusers", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "linkedin_id"
    t.string   "location"
    t.integer  "num_connections"
    t.string   "picture_url"
    t.string   "public_profile_url"
    t.integer  "separation_degree"
    t.integer  "total_positions"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "positions", :force => true do |t|
    t.integer  "position_linkedin_id"
    t.string   "title"
    t.text     "summary"
    t.boolean  "is_current"
    t.integer  "linkedinuser_id"
    t.integer  "company_linkedin_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
