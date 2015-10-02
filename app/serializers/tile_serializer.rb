class TileSerializer < ActiveModel::Serializer
  attributes :id, :weight, :size, :content_type

  has_one :content
end
