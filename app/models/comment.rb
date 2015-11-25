class Comment < ActiveRecord::Base
  include Notifications
  include Likes

  # Relations
  belongs_to :author, inverse_of: :comments, class_name: User
  belongs_to :commentable, polymorphic: true, counter_cache: true # Album | Photo | Video | Text | Tribute | Relationship

  # Validations
  validates :author, :commentable, :text, presence: true
  validates  :text,  length: {maximum: 100}

  before_create :set_notification_users

  private

  def set_notification_users
    if commentable_type == 'Tribute'
      @notification_users_ids = [commentable.user_id, commentable.author_id]
    elsif commentable_type == 'Relationship'
      @notification_users_ids = [commentable.recipient_id, commentable.sender_id]
    else
      @notification_users_ids = [commentable.user.id]
    end
  end
end
