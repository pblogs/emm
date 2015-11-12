class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url, :background_url, :relationship_id, :unread_notifications_count

  has_one :relationship, serializer: RelationshipSerializer

  def avatar_url
    object.avatar
  end

  def background_url
    object.background
  end

  def include_relationship?
    options[:with_relationship]
  end

  def include_relationship_id?
    object.try(:relationship_id)
  end

  #incoming/outgoing/friends/related_users return relationship_id between two users
  def relationship_id
    object.relationship_id
  end

  # Relation to current user
  def relationship
    return nil if options[:current_user] && options[:current_user].id == object.id
    options[:current_user_relationships] ?
        options[:current_user_relationships].find { |r| r.sender_id == object.id || r.recipient_id == object.id } :
        object.relation_to(options[:current_user].id)
  end
end
