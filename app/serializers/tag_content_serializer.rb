class TagContentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :author_id, :target_type, :has_tile

  has_one :target

  def has_tile
    object.target.tile.present?
  end
end
