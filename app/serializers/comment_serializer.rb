class CommentSerializer < LikableContentSerializer
  attributes :id, :text, :commentable_id, :commentable_type

  has_one :author
end
