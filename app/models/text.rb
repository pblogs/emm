class Text < ActiveRecord::Base

  include AlbumRecord
  include SanitizeDescription

  # Validations
  validates :album, :title, :description, presence: true
end
