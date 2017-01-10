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

ActiveRecord::Schema.define(version: 20170104142725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answered_questions", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.boolean  "correct"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "lesson_id"
    t.text     "answer"
    t.float    "streak_mtp"
    t.float    "correctness"
    t.index ["lesson_id"], name: "index_answered_questions_on_lesson_id", using: :btree
    t.index ["question_id"], name: "index_answered_questions_on_question_id", using: :btree
    t.index ["user_id"], name: "index_answered_questions_on_user_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.string   "label"
    t.string   "solution"
    t.string   "hint"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "question_id"
    t.string   "answer_type", default: "normal"
    t.index ["question_id"], name: "index_answers_on_question_id", using: :btree
  end

  create_table "choices", force: :cascade do |t|
    t.string   "content"
    t.boolean  "correct"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "question_id"
    t.index ["question_id"], name: "index_choices_on_question_id", using: :btree
  end

  create_table "choices_images", id: false, force: :cascade do |t|
    t.integer "choice_id"
    t.integer "image_id"
    t.index ["choice_id"], name: "index_choices_images_on_choice_id", using: :btree
    t.index ["image_id"], name: "index_choices_images_on_image_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "author",     null: false
    t.text     "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "job_id"
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.index ["job_id"], name: "index_comments_on_job_id", using: :btree
    t.index ["ticket_id"], name: "index_comments_on_ticket_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "hexcolor"
    t.integer  "sort_order"
  end

  create_table "current_questions", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["lesson_id"], name: "index_current_questions_on_lesson_id", using: :btree
    t.index ["question_id"], name: "index_current_questions_on_question_id", using: :btree
    t.index ["user_id"], name: "index_current_questions_on_user_id", using: :btree
  end

  create_table "current_topic_questions", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_current_topic_questions_on_question_id", using: :btree
    t.index ["topic_id"], name: "index_current_topic_questions_on_topic_id", using: :btree
    t.index ["user_id"], name: "index_current_topic_questions_on_user_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "question_id"
    t.integer  "job_id"
    t.index ["job_id"], name: "index_images_on_job_id", using: :btree
    t.index ["question_id"], name: "index_images_on_question_id", using: :btree
  end

  create_table "images_tags", id: false, force: :cascade do |t|
    t.integer "image_id"
    t.integer "tag_id"
    t.index ["image_id"], name: "index_images_tags_on_image_id", using: :btree
    t.index ["tag_id"], name: "index_images_tags_on_tag_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "example_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "duration"
    t.string   "status"
    t.float    "price"
    t.integer  "creator_id"
    t.integer  "worker_id"
    t.integer  "completed_by"
  end

  create_table "jobs_questions", force: :cascade do |t|
    t.integer "question_id"
    t.integer "job_id"
    t.index ["job_id"], name: "index_jobs_questions_on_job_id", using: :btree
    t.index ["question_id"], name: "index_jobs_questions_on_question_id", using: :btree
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "video"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "topic_id"
    t.integer  "sort_order"
    t.integer  "pass_experience"
    t.string   "status",          default: "Test", null: false
    t.index ["topic_id"], name: "index_lessons_on_topic_id", using: :btree
  end

  create_table "lessons_questions", id: false, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "question_id"
    t.index ["lesson_id"], name: "index_lessons_questions_on_lesson_id", using: :btree
    t.index ["question_id"], name: "index_lessons_questions_on_question_id", using: :btree
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

  create_table "question_resets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.integer  "question_id"
    t.integer  "count"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_question_resets_on_user_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "question_text"
    t.string   "solution"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "difficulty_level"
    t.integer  "experience"
    t.string   "order"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "solution_image_file_name"
    t.string   "solution_image_content_type"
    t.integer  "solution_image_file_size"
    t.datetime "solution_image_updated_at"
    t.integer  "job_id"
    t.index ["job_id"], name: "index_questions_on_job_id", using: :btree
  end

  create_table "questions_tags", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "tag_id"
    t.index ["question_id"], name: "index_questions_tags_on_question_id", using: :btree
    t.index ["tag_id"], name: "index_questions_tags_on_tag_id", using: :btree
  end

  create_table "questions_topics", id: false, force: :cascade do |t|
    t.integer "topic_id"
    t.integer "question_id"
    t.index ["question_id"], name: "index_questions_topics_on_question_id", using: :btree
    t.index ["topic_id"], name: "index_questions_topics_on_topic_id", using: :btree
  end

  create_table "questions_users", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "user_id"
    t.index ["question_id"], name: "index_questions_users_on_question_id", using: :btree
    t.index ["user_id"], name: "index_questions_users_on_user_id", using: :btree
  end

  create_table "student_lesson_exps", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.integer  "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "streak_mtp"
    t.index ["lesson_id"], name: "index_student_lesson_exps_on_lesson_id", using: :btree
    t.index ["user_id"], name: "index_student_lesson_exps_on_user_id", using: :btree
  end

  create_table "student_topic_exps", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.integer  "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "streak_mtp"
    t.index ["topic_id"], name: "index_student_topic_exps_on_topic_id", using: :btree
    t.index ["user_id"], name: "index_student_topic_exps_on_user_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "tags_tickets", id: false, force: :cascade do |t|
    t.integer "ticket_id"
    t.integer "tag_id"
    t.index ["tag_id"], name: "index_tags_tickets_on_tag_id", using: :btree
    t.index ["ticket_id"], name: "index_tags_tickets_on_ticket_id", using: :btree
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "title",      default: "Dummy title", null: false
    t.integer  "owner_id",                           null: false
    t.integer  "agent_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "status",     default: "Open",        null: false
    t.integer  "streak_mtp"
  end

  create_table "tickets_questions", id: false, force: :cascade do |t|
    t.integer "ticket_id"
    t.integer "question_id"
    t.index ["question_id"], name: "index_tickets_questions_on_question_id", using: :btree
    t.index ["ticket_id"], name: "index_tickets_questions_on_ticket_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "unit_id"
    t.integer  "level_one_exp"
    t.integer  "max_level"
    t.float    "level_multiplier"
    t.integer  "sort_order"
    t.index ["unit_id"], name: "index_topics_on_unit_id", using: :btree
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "course_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "job_id"
    t.index ["course_id"], name: "index_units_on_course_id", using: :btree
    t.index ["job_id"], name: "index_units_on_job_id", using: :btree
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "answered_questions", "lessons"
  add_foreign_key "answered_questions", "questions"
  add_foreign_key "answered_questions", "users"
  add_foreign_key "answers", "questions"
  add_foreign_key "choices", "questions"
  add_foreign_key "comments", "jobs"
  add_foreign_key "comments", "tickets"
  add_foreign_key "comments", "users"
  add_foreign_key "current_questions", "lessons"
  add_foreign_key "current_questions", "questions"
  add_foreign_key "current_questions", "users"
  add_foreign_key "current_topic_questions", "questions"
  add_foreign_key "current_topic_questions", "topics"
  add_foreign_key "current_topic_questions", "users"
  add_foreign_key "images", "jobs"
  add_foreign_key "images", "questions"
  add_foreign_key "jobs_questions", "jobs"
  add_foreign_key "jobs_questions", "questions"
  add_foreign_key "lessons", "topics"
  add_foreign_key "question_resets", "users"
  add_foreign_key "questions", "jobs"
  add_foreign_key "student_lesson_exps", "lessons"
  add_foreign_key "student_lesson_exps", "users"
  add_foreign_key "student_topic_exps", "topics"
  add_foreign_key "student_topic_exps", "users"
  add_foreign_key "topics", "units"
  add_foreign_key "units", "courses"
  add_foreign_key "units", "jobs"
end
