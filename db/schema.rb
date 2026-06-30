# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_27_155732) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "lawyer_id", null: false
    t.boolean "paid"
    t.integer "proposed_fee_pence"
    t.bigint "question_id", null: false
    t.text "response_text"
    t.datetime "updated_at", null: false
    t.index ["lawyer_id"], name: "index_answers_on_lawyer_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "payment_requests", force: :cascade do |t|
    t.bigint "answer_id", null: false
    t.datetime "created_at", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_payment_requests_on_answer_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "body"
    t.string "category"
    t.datetime "created_at", null: false
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.integer "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users", column: "lawyer_id"
  add_foreign_key "payment_requests", "answers"
  add_foreign_key "questions", "users"
end
