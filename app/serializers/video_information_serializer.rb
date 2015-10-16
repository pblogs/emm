class VideoInformationSerializer < ActiveModel::Serializer
  attributes :title, :description, :remote_picture_url, :video_id, :source_url, :source
end
