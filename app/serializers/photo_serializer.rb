class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :album_id, :title, :description, :image, :created_at
end
