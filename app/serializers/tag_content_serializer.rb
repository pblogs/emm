class TagContentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :author_id, :target_type

  has_one :target
  has_one :tile

  def tile
    object.target.tile
  end
end
