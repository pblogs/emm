class CommentSerializer < LikableContentSerializer
  attributes :id, :text, :commentable_id, :commentable_type

  has_one :author
  has_one :commentable

  def include_commentable?
    options[:notifications]
  end
end
