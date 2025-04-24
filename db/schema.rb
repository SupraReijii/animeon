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

ActiveRecord::Schema[7.1].define(version: 2025_04_24_134157) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.integer "episodes_aired", default: 0, null: false
    t.string "poster_file_name"
    t.string "poster_content_type"
    t.bigint "poster_file_size"
    t.datetime "poster_updated_at"
  end

  create_table "episodes", force: :cascade do |t|
    t.string "name"
    t.bigint "anime_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "episode_number", default: 0, null: false
    t.index ["anime_id"], name: "index_episodes_on_anime_id"
  end

  create_table "fandubs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "members", default: [], null: false, array: true
    t.date "date_of_foundation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fandubs_videos", id: false, force: :cascade do |t|
    t.bigint "video_id", null: false
    t.bigint "fandub_id", null: false
  end

  create_table "franchises", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "animes", default: [], null: false, array: true
    t.float "score", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.string "russian"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "role", default: "user", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "video_urls", force: :cascade do |t|
    t.string "url"
    t.bigint "video_id"
    t.string "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 0, null: false
    t.index ["video_id"], name: "index_video_urls_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "episode_id"
    t.bigint "fandub_id"
    t.string "quality", array: true
    t.index ["episode_id"], name: "index_videos_on_episode_id"
    t.index ["fandub_id"], name: "index_videos_on_fandub_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
