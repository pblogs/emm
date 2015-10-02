class RecordSerializer < ActiveModel::Serializer
  attributes :id, :weight

  has_one :content
end
