class Tile < ActiveRecord::Base

  CELLS_PER_PAGE = 24 # 6x4 grid on large screen (one tile could occupy from 1 to 4 cells)

  # Relations
  belongs_to :page, inverse_of: :tiles
  delegate :user, to: :page, allow_nil: true # belongs to user through page
  belongs_to :content, polymorphic: true # Album | Photo | Video | Text | Tribute

  # Enums
  enum widget_type: [:media, :avatar, :info]
  enum size: [:small, :middle, :large, :vertical]
  enum screen_size: [:lg, :md, :sm]

  # Validations
  validates :page, :size, presence: true
  validates :content, presence: true, if: :media?

  # Scopes
  default_scope { order(row: :asc).order(col: :asc).order(created_at: :asc) } # Order by rows and columns (top left is first). Oldest tiles appears first if rows and columns are not set

  # Callbacks
  before_create :check_for_free_space_on_page
  after_destroy :remove_empty_page

  private

  def check_for_free_space_on_page
    target_page_tile_sizes = self.page.tiles.pluck(:size)
    # Calculate total square occupied by tiles already existing on the page
    total_square = target_page_tile_sizes.inject(0) do |result, tile_size_id|
      next result + 1 if Tile.sizes.invert[tile_size_id] == 'small'
      next result + 2 if Tile.sizes.invert[tile_size_id] == 'middle'
      next result + 4 if Tile.sizes.invert[tile_size_id] == 'large'
      next result + 2 if Tile.sizes.invert[tile_size_id] == 'vertical'
      next result
    end
    # If the page is filled with tiles, create new page and place new tile on those page
    self.page = page.user.pages.create if total_square >= CELLS_PER_PAGE
  end

  def remove_empty_page
    self.page.destroy if !self.page.default? && self.page.tiles.count == 0
  end
end
