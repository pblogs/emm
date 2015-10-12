class TileSimpleSerializer < ActiveModel::Serializer
  attributes :id, :widget_type, :content_type, :size

  has_one :content

  def content_type
    object.content_type.downcase if object.content_type
  end

  def include_content?
    !options[:skip_content]
  end
end
