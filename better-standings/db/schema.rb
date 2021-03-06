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

ActiveRecord::Schema.define(version: 2019_12_13_051748) do

  create_table "conferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
  end

  create_table "games", force: :cascade do |t|
    t.integer "nhl_identifier"
    t.integer "away_team_id"
    t.integer "home_team_id"
    t.integer "first_star_player_id"
    t.integer "second_star_player_id"
    t.integer "third_star_player_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "gametime"
    t.integer "winning_team_id"
    t.integer "losing_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "nhl_identifier"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "team_games", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "team_id", null: false
    t.boolean "win"
    t.string "home_game"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_team_games_on_game_id"
    t.index ["team_id"], name: "index_team_games_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "division"
    t.integer "standings_points"
    t.integer "games_played"
    t.integer "regulation_wins"
    t.integer "conference_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "nhl_identifier"
    t.float "points_per_game"
    t.float "reg_wins_in_82"
    t.string "slug"
    t.index ["conference_id"], name: "index_teams_on_conference_id"
  end

  add_foreign_key "players", "teams"
  add_foreign_key "team_games", "games"
  add_foreign_key "team_games", "teams"
  add_foreign_key "teams", "conferences"
end
