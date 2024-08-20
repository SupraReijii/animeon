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

ActiveRecord::Schema[7.1].define(version: 2024_08_20_091328) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "episodes", default: 0, null: false
    t.string "status"
    t.decimal "user_rating", default: "0.0", null: false
    t.string "franchise"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind"
    t.integer "duration"
    t.string "age_rating"
    t.string "russian", default: "", null: false
    t.string "english"
    t.string "japanese"
    t.integer "shiki_id"
    t.string "season"
    t.integer "genres", default: [], null: false, array: true
  end

  create_table "episodes", force: :cascade do |t|
    t.string "name"
    t.bigint "anime_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "episode_number", default: 0, null: false
    t.index ["anime_id"], name: "index_episodes_on_anime_id"
  end

  create_table "videos", force: :cascade do |t|
    t.string "url"
    t.string "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "episode_id"
    t.index ["episode_id"], name: "index_videos_on_episode_id"
  end

end
