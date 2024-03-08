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

ActiveRecord::Schema[7.1].define(version: 2024_03_08_025248) do
  create_table "game_events", force: :cascade do |t|
    t.integer "event_type"
    t.string "description"
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_events_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "kills_count"
    t.integer "players_count"
    t.json "params", default: {}
    t.json "json", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kills", force: :cascade do |t|
    t.integer "death_type_id"
    t.integer "killer_id"
    t.integer "victim_id", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_kills_on_game_id"
    t.index ["killer_id"], name: "index_kills_on_killer_id"
    t.index ["victim_id"], name: "index_kills_on_victim_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "session_id"
    t.string "team"
    t.integer "score", default: 0
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["session_id", "game_id"], name: "index_players_on_session_id_and_game_id", unique: true
  end

  add_foreign_key "game_events", "games"
  add_foreign_key "kills", "games"
  add_foreign_key "kills", "players", column: "killer_id"
  add_foreign_key "kills", "players", column: "victim_id"
  add_foreign_key "players", "games"
end
