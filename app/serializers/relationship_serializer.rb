class RelationshipSerializer < ActiveModel::Serializer
  attributes :id, :status

  has_one :related_user

  def related_user
    return object.recipient if object.sender_id == options[:current_user].id
    return object.sender if object.recipient_id == options[:current_user].id
    nil
  end
end
