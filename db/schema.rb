# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_01_153829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "multiple_choices", force: :cascade do |t|
    t.string "option_a"
    t.string "option_b"
    t.string "option_c"
    t.string "option_d"
    t.string "option_e"
    t.string "correct_option"
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_multiple_choices_on_question_id"
  end

  create_table "paper_tests", force: :cascade do |t|
    t.bigint "paper_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paper_id"], name: "index_paper_tests_on_paper_id"
    t.index ["user_id"], name: "index_paper_tests_on_user_id"
  end

  create_table "papers", force: :cascade do |t|
    t.string "subject"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "name"
    t.bigint "paper_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paper_id"], name: "index_questions_on_paper_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.boolean "is_correct", default: false
    t.string "selected_option"
    t.bigint "question_id", null: false
    t.bigint "user_id", null: false
    t.bigint "paper_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paper_id"], name: "index_user_answers_on_paper_id"
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_block", default: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "multiple_choices", "questions"
  add_foreign_key "paper_tests", "papers"
  add_foreign_key "paper_tests", "users"
  add_foreign_key "questions", "papers"
  add_foreign_key "user_answers", "papers"
  add_foreign_key "user_answers", "questions"
  add_foreign_key "user_answers", "users"
end
