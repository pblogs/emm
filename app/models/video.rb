class Video < ActiveRecord::Base

  include AlbumRecord

  # Validations
  validates :album, presence: true
  validates :source, presence: true, if: :video_id

  # Uploaders
  mount_base64_uploader :preview, PhotoUploader

  enum source: { youtube: 0, vimeo: 1 }
end
