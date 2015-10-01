class Video < ActiveRecord::Base

  include AlbumRecord

  # Validations
  validates :album, :video_id, :preview, presence: true

  # Uploaders
  mount_uploader :preview, PhotoUploader
end
