class TileSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :widget_type, :content_type, :size, :row, :col, :screen_size

  has_one :content

  def content_type
    object.content_type.downcase if object.content_type
  end
end
