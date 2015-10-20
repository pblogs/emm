class RelationshipSerializer < ActiveModel::Serializer
  attributes :id, :status

  has_one :friend

  def friend
    object.user == current_user ? object.user : object.friend
  end
end
