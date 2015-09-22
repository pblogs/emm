class Tribute < ActiveRecord::Base

  # Relations
  belongs_to :author, class_name: User
  belongs_to :user, inverse_of: :tributes
  has_one :tile, as: :content, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :author, :user, :title, :description, presence: true

  # Methods
  def create_tile_on_user_page
    self.create_tile(user: self.user)
  end
end
