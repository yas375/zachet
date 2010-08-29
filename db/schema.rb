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

ActiveRecord::Schema.define(:version => 20100829061923) do

  create_table "attaches", :force => true do |t|
    t.integer  "container_id",      :null => false
    t.string   "container_type",    :null => false
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "colleges", :force => true do |t|
    t.string   "subdomain"
    t.string   "abbr"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_cribs", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.integer  "discipline_id"
    t.integer  "teacher_id"
    t.boolean  "commented",     :default => false, :null => false
    t.boolean  "published",     :default => false, :null => false
    t.boolean  "promoted",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_manuals", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "type"
    t.integer  "author_id"
    t.integer  "discipline_id"
    t.boolean  "commented",     :default => false, :null => false
    t.boolean  "published",     :default => false, :null => false
    t.boolean  "promoted",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_synopses", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "year"
    t.integer  "author_id"
    t.integer  "discipline_id"
    t.integer  "teacher_id"
    t.boolean  "commented",     :default => false, :null => false
    t.boolean  "published",     :default => false, :null => false
    t.boolean  "promoted",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_colleges", :force => true do |t|
    t.integer "college_id"
    t.integer "newsitem_id"
  end

  create_table "newsitems", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_jobs", :force => true do |t|
    t.integer  "teacher_id",    :null => false
    t.integer  "college_id",    :null => false
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_photos", :force => true do |t|
    t.integer  "teacher_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_subjects", :force => true do |t|
    t.integer  "discipline_id"
    t.integer  "teacher_job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "college_id"
  end

end
