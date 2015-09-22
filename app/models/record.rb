class Record < ActiveRecord::Base

  # Relations
  belongs_to :album, inverse_of: :records
  belongs_to :content, polymorphic: true # Photo | Video | Text

  # Validations
  validates :album, :content, :weight, presence: true

  # Scopes
  default_scope { order(weight: :desc).order(created_at: :asc) }  # Tiles with bigger weight appears first (within same weight the most recent will be last)
end
