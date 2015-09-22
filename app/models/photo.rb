class Photo < ActiveRecord::Base

  # Relations
  belongs_to :album, inverse_of: :photos
  has_one :record, as: :content, dependent: :destroy
  has_one :tile, as: :content, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :album, :image, presence: true
end
