class Relationship < ActiveRecord::Base
  enum status: { pending: 0, accepted: 1, declined: 2 }

  belongs_to :user#, counter_cache: true
  belongs_to :friend, class_name: 'User'

  validates :user, presence: true
  validates :friend, presence: true, uniqueness: { scope: :user }
  validate :not_self
  validate :validate_status, on: :update

  private

  def validate_status
    errors.add(:status, I18n.t('activerecord.errors.models.relationship.wrong_status')) if status_was != 'pending'
  end

  def not_self
    errors.add(:friend, I18n.t('activerecord.errors.models.relationship.self_relation')) if user == friend
  end
end
