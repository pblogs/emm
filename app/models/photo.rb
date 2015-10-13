class Photo < ActiveRecord::Base

  include AlbumRecord
  include SanitizeDescription

  # Validations
  validates :album, :image, presence: true

  # Uploaders
  mount_base64_uploader :image, PhotoUploader
end
