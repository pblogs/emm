class Tile < ActiveRecord::Base

  # Relations
  belongs_to :user, inverse_of: :tiles
  belongs_to :content, polymorphic: true # Album | Photo | Video | Text | Tribute

  # Enums
  enum size: [:small, :middle, :large]

  # Validations
  validates :user, :weight, :size, presence: true

  # Scopes
  default_scope { order(weight: :desc).order(created_at: :desc) } # Tiles with bigger weight appears first (within same weight the most recent will be first)

  # Callbacks
  before_create :set_weight

  private

  def set_weight
    # TODO not correct - weight should be set based on user's tiles, not all tiles
    self.weight = Tile.first.weight.next if Tile.exists?
  end
end
