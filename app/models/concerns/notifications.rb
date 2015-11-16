module Notifications
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :content, dependent: :delete_all
    after_create :create_notifications
  end

  private

  def create_notifications
    event = self.class.name.downcase
    (@notification_users_ids || []).each do |user_id|
      next if (event == 'like' && self.user_id == user_id) || (event == 'comment' && self.author_id == user_id)
      self.notifications.create(event: self.class.name.downcase, user_id: user_id)
    end
    true
  end
end
