class Album < ActiveRecord::Base

  # Relations
  belongs_to :user, inverse_of: :albums
  has_one :tile, as: :content, dependent: :destroy
  has_many :photos, inverse_of: :album, dependent: :destroy
  has_many :texts, inverse_of: :album, dependent: :destroy
  has_many :videos, inverse_of: :album, dependent: :destroy
  has_many :records, inverse_of: :album # no need to dependent destroy - record will be destroyed by it's content
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :user, :title, presence: true

  # Callbacks
  before_destroy :check_for_default

  private

  def check_for_default
    if self.default? && !self.destroyed_by_association
      errors.add(:base, 'Cannot delete default album')
      false
    end
  end
end
