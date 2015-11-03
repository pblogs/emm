class TagContentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :author_id, :target_type

  has_one :target
end
