class Photo < ActiveRecord::Base

  include AlbumRecord

  # Validations
  validates :album, :image, presence: true

  # Uploaders
  mount_base64_uploader :image, PhotoUploader
end
