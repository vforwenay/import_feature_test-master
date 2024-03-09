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

ActiveRecord::Schema.define(version: 20170117112140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "import_requests", force: :cascade do |t|
    t.string   "state"
    t.text     "message"
    t.datetime "extract_time"
    t.string   "import_file"
    t.string   "import_for"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.text     "error_message"
  end

  create_table "inventories", force: :cascade do |t|
    t.string   "inventory_type"
    t.integer  "item_number"
    t.integer  "org_number"
    t.integer  "quantity"
    t.string   "status"
    t.date     "last_ship_date"
    t.date     "due_date"
    t.integer  "lot"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "item_number"
    t.string   "item_description"
    t.string   "item_status"
    t.string   "category"
    t.string   "sale_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
