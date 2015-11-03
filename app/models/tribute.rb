class Tribute < ActiveRecord::Base
  include Likes

  # Relations
  belongs_to :author, class_name: User
  belongs_to :user, inverse_of: :tributes
  has_one :tile, as: :content, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :author, :user, :description, presence: true

  validate do
    errors.add(:user_id, 'Cannot create tribute for self') if user_id == author_id
  end

  # Methods
  def create_tile_on_user_page(page=nil)
    page = page || self.user.pages.last
    self.create_tile(page: page)
  end

  def has_tile?
    tile.present?
  end
end
