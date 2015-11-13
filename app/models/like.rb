class Like < ActiveRecord::Base
  include Notifications

  TARGETS = %w(comment video text photo tribute album)

  validates :user, uniqueness: { scope: [:target_id, :target_type],
                                 message: I18n.t('activerecord.errors.models.like.already_liked') }

  belongs_to :user, inverse_of: :likes
  belongs_to :target, polymorphic: true, inverse_of: :likes, counter_cache: true

  before_create :set_notification_users

  private

  def set_notification_users
    if target_type == 'Comment' || target_type == 'Tribute'
      @notification_users_ids = [target.author_id]
    else
      @notification_users_ids = [target.user.id]
    end
  end
end
