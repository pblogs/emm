class LikableContentSerializer < ActiveModel::Serializer
  attributes :likes_count

  has_one :like, serializer: LikeSerializer

  def include_like?
    options[:with_likes]
  end

  def like
    if options[:content_likes]
      options[:content_likes].detect { |like| like.target_type == object.class.name && like.target_id == object.id }
    else
      object.likes.find_by(user_id: current_user.id)
    end
  end
end
