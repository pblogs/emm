class Tag < ActiveRecord::Base
  include Notifications

  TARGETS = %w(album photo video text)

  # Relations
  belongs_to :author, class_name: 'User', inverse_of: :authored_tags
  belongs_to :user, inverse_of: :tags
  belongs_to :target, polymorphic: true, inverse_of: :tags, counter_cache: true # Album | Photo | Video | Text

  # Validations
  validates :author, :user, :target, presence: true
  validate :not_existing

  before_create :set_notification_users

  def not_existing
    return if self.target.blank?
    errors.add(:user, I18n.t('activerecord.errors.models.tag.tag_exists')) if self.target.tags.find_by_user_id(self.user_id).present?
  end

  private

  def set_notification_users
    @notification_users_ids = [user_id]
  end
end
