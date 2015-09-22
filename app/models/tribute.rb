class Tribute < ActiveRecord::Base

  # Relations
  belongs_to :user, inverse_of: :tributes
  belongs_to :author, class_name: User
  has_one :tile, as: :content, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :user, :title, :description, presence: true
end
