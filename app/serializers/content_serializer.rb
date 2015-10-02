class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :album_id, :created_at

  has_one :user
end
