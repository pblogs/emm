class Video < ActiveRecord::Base

  include AlbumRecord

  # Validations
  validates :album, :video_id, :preview, presence: true

  # Uploaders
  mount_base64_uploader :preview, PhotoUploader
end
