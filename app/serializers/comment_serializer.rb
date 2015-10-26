class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :commentable_id, :commentable_type, :likes_count

  has_one :author
end
