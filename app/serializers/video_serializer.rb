class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :preview, :video_id
end
