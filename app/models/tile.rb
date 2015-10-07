class Tile < ActiveRecord::Base

  # Relations
  belongs_to :page, inverse_of: :tiles
  delegate :user, to: :page, allow_nil: true # belongs to user through page
  belongs_to :content, polymorphic: true # Album | Photo | Video | Text | Tribute

  # Enums
  enum size: [:small, :middle, :large, :vertical]

  # Validations
  validates :page, :size, presence: true

  # Scopes
  default_scope { order(row: :asc).order(column: :asc).order(created_at: :asc) } # Order by rows and columns (top left is first). Oldest tiles appears first if rows and columns are not set

  # Callbacks
  before_destroy :remove_empty_page

  private

  def remove_empty_page
    self.page.destroy if !self.page.default? && self.page.tiles.count == 0
  end
end
