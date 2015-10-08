class TileSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :size, :content_type, :row, :col, :screen_size

  has_one :content

  def content_type
    object.content_type.downcase
  end
end
