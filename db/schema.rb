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

ActiveRecord::Schema.define(version: 20130408234300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "films", force: true do |t|
    t.text     "description"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "coming_soon", default: false
  end

  add_index "films", ["title"], name: "index_films_on_title"

  create_table "images", force: true do |t|
    t.integer  "width"
    t.integer  "height"
    t.string   "image_type"
    t.integer  "film_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "poster"
  end

  create_table "showings", force: true do |t|
    t.integer  "film_id"
    t.datetime "showtime"
    t.integer  "theater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "showings", ["film_id"], name: "index_showings_on_film_id"
  add_index "showings", ["theater_id"], name: "index_showings_on_theater_id"

  create_table "theaters", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "theaters", ["url"], name: "index_theaters_on_url", unique: true

end
