class Page < ActiveRecord::Base

  # Relations
  belongs_to :user, inverse_of: :pages
  has_many :tiles, inverse_of: :page # no need to dependent destroy - tile will be destroyed by it's content

  # Validations
  validates :user, :weight, presence: true
  validate :only_one_default_page, if: :default?

  # Scopes
  default_scope { order(weight: :asc).order(created_at: :asc) }  # Pages with lower weight (and the oldest) appears first

  # Callbacks
  before_create :set_weight
  before_destroy :check_for_default

  private

  def set_weight
    last_page = self.user.pages.last
    self.weight = last_page.present? ? last_page.weight.next : 0
  end

  def only_one_default_page
    if self.user.default_page.present? && self.id != self.user.default_page.id
      errors.add(:default, I18n.t('activerecord.errors.models.page.default_page.only_one_allowed'))
      false
    end
  end

  def check_for_default
    if self.default? && !self.destroyed_by_association
      errors.add(:base, I18n.t('activerecord.errors.models.page.default_page.unable_to_destroy'))
      false
    end
  end
end
