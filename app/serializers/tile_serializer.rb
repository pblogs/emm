class TileSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :weight, :size, :content_type

  has_one :content
end
