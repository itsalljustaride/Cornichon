# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111110154115) do

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "sessionrecording_id"
    t.integer  "student_id"
    t.integer  "kind"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
    t.float    "audio_length"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "grouptask_id",                       :null => false
    t.string   "viewable",       :default => "none"
    t.string   "discussionable", :default => "none"
    t.string   "downloadable",   :default => "none"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
