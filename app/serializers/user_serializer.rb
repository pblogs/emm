class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url, :background_url

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

  # Relation to current user
  def relationship
    return nil if options[:current_user] && options[:current_user].id == object.id
    options[:current_user_relationships] ?
        options[:current_user_relationships].find { |r| r.sender_id == object.id || r.recipient_id == object.id } :
        object.relation_to(options[:current_user].id)
  end
end
