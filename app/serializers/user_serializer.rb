class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :birthday, :avatar_url, :background_url, :relation_status

  def avatar_url
    object.avatar
  end

  def background_url
    object.background
  end

  def include_relation_status?
    options[:with_relation]
  end

  def relation_status
    # Relation to current user
    rel = options[:current_user_relationships] ?
        options[:current_user_relationships].find { |r| r.sender_id == object.id || r.recipient_id == object.id } :
        object.relation_to(options[:current_user].id)

    return nil if rel.blank?
    return 'friends' if rel.status == 'accepted'
    if rel.sender_id == object.id
      return 'incoming_request_pending' if rel.status == 'pending'
      return 'incoming_request_declined' if rel.status == 'declined'
    else
      return 'outgoing_request_pending' if rel.status == 'pending'
      return 'outgoing_request_declined' if rel.status == 'declined'
    end
  end
end
