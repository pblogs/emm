class RecordSerializer < ActiveModel::Serializer
  attributes :id, :weight, :content_type

  has_one :content

  def content_type
    object.content_type.downcase if object.content_type
  end

end
