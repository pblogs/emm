class RecordSerializer < ActiveModel::Serializer
  attributes :id, :weight, :content_type

  has_one :content

  def content_type
    object.content_type.downcase if object.content_type
  end

  def include_content?
    !options[:skip_content]
  end
end
