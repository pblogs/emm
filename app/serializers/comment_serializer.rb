class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author_id, :text, :commentable_id, :commentable_type
end
