class Album < ActiveRecord::Base

  # Relations
  belongs_to :user, inverse_of: :albums
  has_one :tile, as: :content, dependent: :destroy
  has_many :photos, inverse_of: :album, dependent: :destroy
  has_many :texts, inverse_of: :album, dependent: :destroy
  has_many :videos, inverse_of: :album, dependent: :destroy
  has_many :records, inverse_of: :album # no need to dependent destroy - record will be destroyed by it's content
  has_many :comments, as: :commentable, dependent: :destroy

  enum privacy: { hidden: 0, for_friends: 1, for_all: 2 }

  # Validations
  validates :user, :title, presence: true
  validates :privacy, inclusion: { in: %w(for_friends for_all) }, unless: :default?
  validate :only_one_default_album, if: :default?

  # Callbacks
  after_create :create_tile_on_user_page, unless: :default?
  before_destroy :check_for_default

  # Scopes
  default_scope { order(created_at: :asc) }
  scope :by_privacy, -> (privacy) { where(privacy: Album.privacies[privacy]) }

  # Uploaders
  mount_base64_uploader :cover, AlbumUploader

  # Methods 
  def create_tile_on_user_page(page_id=nil)
    page_id = page_id || self.user.pages.last.id
    self.create_tile(page_id: page_id)
  end
  
  private

  def only_one_default_album
    if self.user.default_album.present? && self.id != self.user.default_album.id
      errors.add(:default, I18n.t('activerecord.errors.models.album.default_album.only_one_allowed'))
      false
    end
  end

  def check_for_default
    if self.default? && !self.destroyed_by_association
      errors.add(:base, I18n.t('activerecord.errors.models.album.default_album.unable_to_destroy'))
      false
    end
  end
end
