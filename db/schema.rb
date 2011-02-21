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

ActiveRecord::Schema.define(:version => 20110221193419) do

  create_table "attaches", :force => true do |t|
    t.integer  "container_id",                      :null => false
    t.string   "container_type",                    :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "description",       :default => ""
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "authors"
    t.string   "publishing_company"
    t.string   "year"
    t.text     "content"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colleges", :force => true do |t|
    t.string   "subdomain"
    t.string   "abbr"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text"
    t.integer  "author_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "control_works", :force => true do |t|
    t.string   "title"
    t.string   "theme"
    t.string   "number"
    t.string   "variant"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cribs", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "teacher"
    t.string   "semester"
    t.integer  "number_of_questions"
    t.integer  "number_of_questions_with_answers"
    t.text     "questions"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "faculty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "drupal_nid"
  end

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "drupal_tid"
  end

  create_table "faculties", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "college_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "last_post_id"
    t.integer  "topics_count", :default => 0
    t.integer  "posts_count",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graduate_works", :force => true do |t|
    t.string   "title"
    t.string   "theme"
    t.string   "author"
    t.string   "year"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "laboratory_practicals", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "authors"
    t.string   "publishing_company"
    t.string   "year"
    t.text     "content"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labs", :force => true do |t|
    t.string   "title"
    t.string   "theme"
    t.string   "number"
    t.string   "variant"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manuals", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "authors"
    t.string   "publishing_company"
    t.string   "year"
    t.text     "content"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materials", :force => true do |t|
    t.string   "title"
    t.integer  "created_by_id"
    t.integer  "discipline_id"
    t.boolean  "commented",     :default => false
    t.boolean  "published",     :default => false
    t.boolean  "promoted",      :default => false
    t.integer  "data_id"
    t.string   "data_type"
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
    t.integer  "author_id"
    t.text     "teaser"
    t.boolean  "commented",  :default => false, :null => false
  end

  create_table "others", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.text     "text"
    t.integer  "author_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redirection_histories", :force => true do |t|
    t.string   "ip"
    t.string   "user_agent"
    t.string   "http_host"
    t.string   "request_uri"
    t.integer  "redirection_rule_id"
    t.string   "destination"
    t.text     "env"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redirection_rules", :force => true do |t|
    t.string   "old_path"
    t.string   "subdomain"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "new_path"
  end

  add_index "redirection_rules", ["old_path"], :name => "index_redirection_rules_on_old_path", :unique => true

  create_table "referats", :force => true do |t|
    t.string   "title"
    t.string   "theme"
    t.string   "author"
    t.string   "year"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "synopses", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "teacher"
    t.string   "semester"
    t.string   "year"
    t.text     "description"
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
    t.integer  "author_id"
    t.string   "post"
    t.integer  "drupal_nid"
  end

  create_table "term_papers", :force => true do |t|
    t.string   "title"
    t.string   "theme"
    t.string   "author"
    t.string   "year"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.string   "subject"
    t.integer  "author_id"
    t.integer  "last_post_id"
    t.boolean  "locked",       :default => false
    t.boolean  "sticky",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count",  :default => 0
  end

  create_table "typical_calculations", :force => true do |t|
    t.string   "title"
    t.string   "theme"
    t.string   "number"
    t.string   "variant"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "college_id"
    t.boolean  "active",              :default => false, :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "birthday"
    t.string   "city"
    t.string   "twitter"
    t.string   "jabber"
    t.string   "skype"
    t.string   "icq"
    t.text     "description"
    t.string   "faculty"
    t.string   "speciality"
    t.string   "loved_discipline"
    t.string   "unloved_discipline"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "drupal_uid"
  end

  create_table "visits_counters", :force => true do |t|
    t.integer  "visitable_id"
    t.string   "visitable_type"
    t.integer  "count",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits_logs", :force => true do |t|
    t.integer  "loggable_id"
    t.string   "loggable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip"
  end

end
