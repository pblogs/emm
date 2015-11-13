class Relationship < ActiveRecord::Base
  enum status: {pending: 0, accepted: 1, declined: 2}

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :tiles, as: :content, dependent: :destroy

  validates :sender, :status, presence: true
  validates :recipient, presence: true, uniqueness: {scope: :sender, message: I18n.t('activerecord.errors.models.relationship.relationship_exists')}
  validates :status, inclusion: {in: %w[accepted declined]}, on: :update, if: 'status_was != "pending"'
  validate :not_self, :no_inverse_relation

  after_update :create_tiles, if: :accepted?

  def show_tile_on_user_page(user, page)
    tile = self.tiles.joins(:page).find_by('pages.user_id = ?', user.id).present?
    tile.update_attributes(page: page || self.album.user.pages.last, visible: true) if tile
  end

  private

  def create_tiles
    [sender, recipient].each do |owner|
      self.tiles.create(page: owner.pages.last, widget_type: :media, visible: false)
    end
  end

  def not_self
    errors.add(:recipient, I18n.t('activerecord.errors.models.relationship.self_relation')) if sender == recipient
  end

  def no_inverse_relation
    if Relationship.where(recipient_id: sender_id, sender_id: recipient_id).exists?
      errors.add(:recipient, I18n.t('activerecord.errors.models.relationship.relationship_exists'))
    end
  end
end
