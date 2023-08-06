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

ActiveRecord::Schema[7.0].define(version: 2023_08_06_102022) do
  create_table "sca_logs", charset: "utf8", force: :cascade do |t|
    t.string "room", null: false
    t.datetime "sca_daytime", null: false
    t.string "sca_rule", null: false
    t.string "sca_name1", null: false
    t.string "sca_name2", null: false
    t.string "sca_name3", null: false
    t.string "sca_name4"
    t.string "sca_score1", null: false
    t.string "sca_score2", null: false
    t.string "sca_score3", null: false
    t.string "sca_score4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scb_logs", charset: "utf8", force: :cascade do |t|
    t.datetime "scb_daytime", null: false
    t.string "scb_rule", null: false
    t.string "scb_name1", null: false
    t.string "scb_name2", null: false
    t.string "scb_name3", null: false
    t.string "scb_name4"
    t.string "scb_score1", null: false
    t.string "scb_score2", null: false
    t.string "scb_score3", null: false
    t.string "scb_score4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
