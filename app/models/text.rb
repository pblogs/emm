class Text < ActiveRecord::Base

  include AlbumRecord

  # Validations
  validates :album, :title, :description, presence: true
end
