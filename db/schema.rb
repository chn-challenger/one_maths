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

ActiveRecord::Schema.define(version: 20160807092602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "maker_id"
    t.index ["maker_id"], name: "index_courses_on_maker_id", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "video"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "topic_id"
    t.integer  "maker_id"
    t.index ["maker_id"], name: "index_lessons_on_maker_id", using: :btree
    t.index ["topic_id"], name: "index_lessons_on_topic_id", using: :btree
  end

  create_table "makers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_makers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_makers_on_reset_password_token", unique: true, using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "question_text"
    t.string   "solution"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "lesson_id"
    t.integer  "maker_id"
    t.index ["lesson_id"], name: "index_questions_on_lesson_id", using: :btree
    t.index ["maker_id"], name: "index_questions_on_maker_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "unit_id"
    t.integer  "maker_id"
    t.index ["maker_id"], name: "index_topics_on_maker_id", using: :btree
    t.index ["unit_id"], name: "index_topics_on_unit_id", using: :btree
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "course_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "maker_id"
    t.index ["course_id"], name: "index_units_on_course_id", using: :btree
    t.index ["maker_id"], name: "index_units_on_maker_id", using: :btree
  end

  add_foreign_key "courses", "makers"
  add_foreign_key "lessons", "makers"
  add_foreign_key "lessons", "topics"
  add_foreign_key "questions", "lessons"
  add_foreign_key "questions", "makers"
  add_foreign_key "topics", "makers"
  add_foreign_key "topics", "units"
  add_foreign_key "units", "courses"
  add_foreign_key "units", "makers"
end
