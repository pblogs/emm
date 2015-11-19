class RelationshipSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :recipient_id, :status, :relation_to_current_user, :relations_with_current_user

  has_one :related_user
  has_one :recipient
  has_one :sender

  def include_sender?
    options[:news_feed] || options[:notifications]
  end

  def include_recipient?
    options[:news_feed] || options[:notifications]
  end

  def include_related_user?
    options[:with_related_user]
  end

  def include_relations_with_current_user?
    options[:news_feed]
  end

  #when you view newsfeed
  def relations_with_current_user
    { relation_with_recipient: current_user.relation_to(recipient_id).try(:status),
      relation_with_sender: current_user.relation_to(sender_id).try(:status) }
  end

  def related_user
    return object.recipient if object.sender_id == options[:current_user].id
    return object.sender if object.recipient_id == options[:current_user].id
    nil
  end

  #when you view list of own relationships
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
