# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151111124558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "description"
    t.string   "cover"
    t.boolean  "default",       default: false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "location_name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "photos_count",  default: 0
    t.integer  "videos_count",  default: 0
    t.integer  "texts_count",   default: 0
    t.integer  "privacy",       default: 0
    t.string   "color"
    t.integer  "likes_count",   default: 0,     null: false
  end

  add_index "albums", ["created_at"], name: "index_albums_on_created_at", using: :btree
  add_index "albums", ["user_id"], name: "index_albums_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "text"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "likes_count",      default: 0, null: false
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "likes", ["target_type", "target_id"], name: "index_likes_on_target_type_and_target_id", using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.string   "content_type"
    t.boolean  "viewed",       default: false
    t.integer  "event"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "notifications", ["content_type", "content_id"], name: "index_notifications_on_content_type_and_content_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "weight",     default: 0
    t.boolean  "default",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pages", ["created_at"], name: "index_pages_on_created_at", using: :btree
  add_index "pages", ["user_id"], name: "index_pages_on_user_id", using: :btree
  add_index "pages", ["weight"], name: "index_pages_on_weight", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "album_id"
    t.string   "title"
    t.string   "description"
    t.string   "image"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "likes_count", default: 0, null: false
    t.integer  "original_id"
  end

  add_index "photos", ["album_id"], name: "index_photos_on_album_id", using: :btree
  add_index "photos", ["created_at"], name: "index_photos_on_created_at", using: :btree

  create_table "records", force: :cascade do |t|
    t.integer  "album_id"
    t.integer  "content_id"
    t.string   "content_type"
    t.integer  "weight",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "records", ["album_id"], name: "index_records_on_album_id", using: :btree
  add_index "records", ["content_id"], name: "index_records_on_content_id", using: :btree
  add_index "records", ["content_type"], name: "index_records_on_content_type", using: :btree
  add_index "records", ["created_at"], name: "index_records_on_created_at", using: :btree
  add_index "records", ["weight"], name: "index_records_on_weight", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "status",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "relationships", ["created_at"], name: "index_relationships_on_created_at", using: :btree
  add_index "relationships", ["recipient_id"], name: "index_relationships_on_recipient_id", using: :btree
  add_index "relationships", ["sender_id"], name: "index_relationships_on_sender_id", using: :btree
  add_index "relationships", ["status"], name: "index_relationships_on_status", using: :btree
  add_index "relationships", ["updated_at"], name: "index_relationships_on_updated_at", using: :btree

  create_table "tags", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "user_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tags", ["author_id"], name: "index_tags_on_author_id", using: :btree
  add_index "tags", ["target_type", "target_id"], name: "index_tags_on_target_type_and_target_id", using: :btree
  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "texts", force: :cascade do |t|
    t.integer  "album_id"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "likes_count", default: 0, null: false
    t.integer  "original_id"
  end

  add_index "texts", ["album_id"], name: "index_texts_on_album_id", using: :btree
  add_index "texts", ["created_at"], name: "index_texts_on_created_at", using: :btree

  create_table "tiles", force: :cascade do |t|
    t.integer  "content_id"
    t.string   "content_type"
    t.integer  "size",         default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "page_id"
    t.integer  "row"
    t.integer  "col"
    t.integer  "screen_size",  default: 0
    t.integer  "widget_type",  default: 0
    t.boolean  "visible",      default: true
  end

  add_index "tiles", ["content_id"], name: "index_tiles_on_content_id", using: :btree
  add_index "tiles", ["content_type"], name: "index_tiles_on_content_type", using: :btree
  add_index "tiles", ["created_at"], name: "index_tiles_on_created_at", using: :btree

  create_table "tributes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "author_id"
    t.string   "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "likes_count", default: 0, null: false
  end

  add_index "tributes", ["author_id"], name: "index_tributes_on_author_id", using: :btree
  add_index "tributes", ["created_at"], name: "index_tributes_on_created_at", using: :btree
  add_index "tributes", ["user_id"], name: "index_tributes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: "", null: false
    t.string   "authentication_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",                       default: 0,  null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.date     "birthday"
    t.string   "avatar"
    t.string   "page_alias"
    t.string   "background"
    t.string   "full_name"
    t.integer  "unread_notifications_count", default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["full_name"], name: "index_users_on_full_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree

  create_table "videos", force: :cascade do |t|
    t.integer  "album_id"
    t.string   "title"
    t.string   "description"
    t.string   "preview"
    t.string   "video_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "source",      default: 0
    t.integer  "duration"
    t.integer  "likes_count", default: 0, null: false
    t.integer  "original_id"
  end

  add_index "videos", ["album_id"], name: "index_videos_on_album_id", using: :btree
  add_index "videos", ["created_at"], name: "index_videos_on_created_at", using: :btree

end
