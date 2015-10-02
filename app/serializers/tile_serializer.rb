class TileSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :weight, :size, :content_type

  has_one :content

  def content_type
    object.content_type.downcase
  end
end
