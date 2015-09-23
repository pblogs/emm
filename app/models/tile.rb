class Tile < ActiveRecord::Base

  # Relations
  belongs_to :user, inverse_of: :tiles
  belongs_to :content, polymorphic: true # Album | Photo | Video | Text | Tribute

  # Enums
  enum size: [:small, :middle, :large]

  # Validations
  validates :user, :weight, :size, presence: true

  # Scopes
  default_scope { order(weight: :desc).order(created_at: :desc) } # Tiles with bigger weight (and most recent) appears first

  # Callbacks
  before_create :set_weight

  private

  def set_weight
    top_tile = self.user.tiles.first
    self.weight = top_tile.present? ? top_tile.weight.next : 0
  end
end
