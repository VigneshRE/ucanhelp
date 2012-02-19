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

ActiveRecord::Schema.define(:version => 20120216171001) do

  create_table "needs", :force => true do |t|
    t.integer  "orphanage_id",                     :null => false
    t.string   "description"
    t.string   "nature"
    t.string   "severity"
    t.string   "status",       :default => "Open"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orphanages", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "nature"
    t.string   "manager_name"
    t.string   "contact_number"
    t.string   "account_details"
    t.string   "email"
    t.string   "secret_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
