class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :viewed, :event
  has_one :content
end
