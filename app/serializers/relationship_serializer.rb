class RelationshipSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :recipient_id, :status, :relation_to_current_user

  has_one :related_user

  def include_related_user?
    options[:with_related_user]
  end

  def related_user
    return object.recipient if object.sender_id == options[:current_user].id
    return object.sender if object.recipient_id == options[:current_user].id
    nil
  end

  def relation_to_current_user
    return nil if options[:current_user].blank?
    if object.sender_id == options[:current_user].id
      return 'friends' if object.status == 'accepted'
      return 'outgoing_request_pending' if object.status == 'pending'
      return 'outgoing_request_declined' if object.status == 'declined'
    elsif object.recipient_id == options[:current_user].id
      return 'friends' if object.status == 'accepted'
      return 'incoming_request_pending' if object.status == 'pending'
      return 'incoming_request_declined' if object.status == 'declined'
    else
      nil
    end
  end
end
