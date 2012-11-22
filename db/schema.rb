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

ActiveRecord::Schema.define(:version => 20121122022104) do

  create_table "playlists", :force => true do |t|
    t.string   "uuid",       :limit => 36
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "playlists", ["uuid"], :name => "index_playlists_on_uuid"

  create_table "plitem_ranks", :force => true do |t|
    t.integer "session_id", :null => false
    t.integer "plitem_id"
    t.integer "rank"
  end

  add_index "plitem_ranks", ["plitem_id"], :name => "index_plitem_ranks_on_plitem_id"
  add_index "plitem_ranks", ["session_id"], :name => "index_plitem_ranks_on_session_id"

  create_table "plitems", :force => true do |t|
    t.string   "youtubeid"
    t.string   "title"
    t.string   "thumbnail"
    t.integer  "length"
    t.integer  "playlist_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.float    "rating"
    t.boolean  "rating_dirty"
  end

  add_index "plitems", ["playlist_id"], :name => "index_plitems_on_playlist_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
