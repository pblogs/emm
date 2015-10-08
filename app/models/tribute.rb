class Tribute < ActiveRecord::Base

  # Relations
  belongs_to :author, class_name: User
  belongs_to :user, inverse_of: :tributes
  has_one :tile, as: :content, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :author, :user, :title, :description, presence: true

  validate do
    errors.add(:user_id, 'Cannot create tribute for self') if user_id == author_id
  end

  # Methods
  def create_tile_on_user_page(page=nil)
    page = page || self.album.user.pages.last
    self.create_tile(page: page)
  end
end
