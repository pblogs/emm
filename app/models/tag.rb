class Tag < ActiveRecord::Base
  TARGETS = %w(album photo video text)

  # Relations
  belongs_to :author, class_name: 'User', inverse_of: :authored_tags
  belongs_to :user, inverse_of: :tags
  belongs_to :target, polymorphic: true, inverse_of: :tags # Album | Photo | Video | Text

  # Validations
  validates :author, :user, :target, presence: true
  validate :not_existing

  def not_existing
    errors.add(:user, I18n.t('activerecord.errors.models.tag.tag_exists')) if self.target.tags.find_by_user_id(self.user_id).present?
  end
end
