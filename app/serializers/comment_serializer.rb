class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :commentable_id, :commentable_type

  has_one :author
end
