class Relationship < ActiveRecord::Base
  enum status: {pending: 0, accepted: 1, declined: 2}

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :sender, presence: true
  validates :recipient, presence: true, uniqueness: {scope: :sender, message: I18n.t('activerecord.errors.models.relationship.relationship_exists')}
  validates :status, inclusion: {in: %w[accepted declined]}, on: :update, if: 'status_was != "pending"'
  validate :not_self, :no_inverse_relation

  private

  def not_self
    errors.add(:recipient, I18n.t('activerecord.errors.models.relationship.self_relation')) if sender == recipient
  end

  def no_inverse_relation
    if Relationship.where(recipient_id: sender_id, sender_id: recipient_id).exists?
      errors.add(:recipient, I18n.t('activerecord.errors.models.relationship.relationship_exists'))
    end
  end
end
